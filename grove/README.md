# docker-rock-grove

[Rock R server](https://www.obiba.org/pages/products/rock/) with DataSHIELD packages as described by [grove](https://datashield.org/help/standard-profiles-and-plaforms) (dsBase, dsTidyverse, dsGeospatial).

This repo builds the image and shows how to add it as a new **profile** to an
[Opal](https://www.obiba.org/pages/products/opal/) server that is **already running**,
whichever way that Opal was deployed. Nothing in Opal's own compose file or
environment needs to change.

## Contents

- [1. Build the image](#1-build-the-image)
- [2. Configure and start grove](#2-configure-and-start-grove)
- [3. Make grove reachable from Opal](#3-make-grove-reachable-from-opal)
- [4. Register grove in Opal](#4-register-grove-in-opal)
- [5. Test from R](#5-test-from-r)
- [Troubleshooting](#troubleshooting)
- [Make targets](#make-targets)

## 1. Build the image

```bash
make build-image     # builds datashield/rock-grove:0.0.0.9000 for linux/amd64
make check           # prints the installed dsBase / dsTidyverse / dsGeospatial versions
```

The base image is amd64-only, so on Apple Silicon the build runs under emulation.
The compose file uses the locally built image; if you have not built it, Docker
will try (and fail) to pull it from Docker Hub.

## 2. Configure and start grove

```bash
cp .env.example .env     # then edit
make up
```

The Rock **administrator** credentials in `.env` must match what Opal uses to log
in to Rock. Opal defaults to `administrator` / `password`
(Opal setting `rock.default.administrator.*`). If your Opal uses other values,
use the same ones here. Changing the credentials on either side needs a restart
of that side, nothing is propagated automatically.

Check that grove answers (the first start can take a minute):

```bash
curl http://localhost:18085/
# { "id": "rock-grove-01", "type": "rock", "cluster": "GROVE", "tags": [...] }
```

That URL works **from your machine**. Opal needs an address that works **from
where Opal runs**, which is what the next step is about.

## 3. Make grove reachable from Opal

> **Do not use `localhost` / `127.0.0.1` in Opal.** Inside the Opal container,
> `localhost` is Opal itself, and 18085 is only a port published on the host.

Pick the case that matches your setup.

| Where does Opal run? | Address to register in Opal | What to do |
|---|---|---|
| In Docker, **same Docker host** as grove | `rock-grove:8085` | Case A below |
| In Docker, but **another machine**, or Opal is installed natively | `http://<grove-host-or-ip>:18085` | Case B below |

### Case A: Opal and grove are both Docker containers on the same host

Containers can only resolve each other by name when they share a Docker network.
Attach grove to Opal's network under the alias `rock-grove`. Use the internal
port **8085** (not the published 18085).

**Option 1: one command (grove already running).**

```bash
make connect-opal
# or:  bash scripts/connect-opal.sh
```

It finds the Opal and grove containers, attaches grove to Opal's network and
checks from inside Opal that `http://rock-grove:8085/` answers. If it cannot
decide (several Opal containers or networks), it tells you which flag to pass:

```bash
make connect-opal connect_args="--opal <opal-container> --network <opal-network> --grove <grove-container>"
```

It is safe to re-run. The attachment is **lost when the grove container is
re-created**, so re-run it after a `--force-recreate`, `make down && make up`, or an
image upgrade. `make disconnect-opal` undoes it.

**Option 2: declarative (survives re-creation).** Put Opal's network name in
`.env` and start grove with the network override:

```bash
# find Opal's network
docker inspect -f '{{range $k,$_ := .NetworkSettings.Networks}}{{println $k}}{{end}}' <opal-container>

echo 'OPAL_NETWORK=<that name>' >> .env
make up-opal
```

Manual equivalent of option 1, if you prefer to see what is happening:

```bash
docker ps --format '{{.Names}}\t{{.Networks}}'
docker network connect --alias rock-grove <opal_network> <grove_container>
```

Notes:
- The network must be user-defined. Docker's default `bridge` network has no
  name resolution; Docker Compose creates user-defined networks, so a compose-deployed
  Opal is fine.
- If Opal and grove are started by different compose projects, they are on
  different networks, which is exactly why this step is needed.

### Case B: Opal is on another machine, or not in Docker

No network trick is needed, just a published port Opal can reach:

- Make sure `PORT` (default 18085) on the grove host is reachable from the Opal
  server (firewall, security group).
- Register `http://<grove-host-or-ip>:18085` in Opal.
- On Docker Desktop, when Opal runs on the same laptop, `host.docker.internal:18085`
  also works from inside the Opal container. On Linux it usually does not
  resolve, so use the machine's IP or DNS name, or Case A.

## 4. Register grove in Opal

Log in to Opal as `administrator`.

1. **Administration > Apps > Discovery**: add the address from step 3
   (`rock-grove:8085` in Case A). Refresh the Apps registry; the grove Rock should
   appear, with its cluster `GROVE`.
2. **Administration > DataSHIELD > Add Profile**: give the profile a name, select the
   cluster `GROVE`, and save.
3. Open the profile, **initialise and enable** it. Opal then inspects the installed R
   packages and publishes their methods. dsBase, dsTidyverse and dsGeospatial should be listed.
4. Check that the DataSHIELD users who need it have permission to use DataSHIELD
   (this is Opal-wide, not per profile in a default setup).

The Discovery entry is stored in Opal's own data, so it survives Opal restarts.
Menu labels differ slightly between Opal versions.

## 5. Test from R

```r
library(DSOpal)
builder <- DSI::newDSLoginBuilder()
builder$append(
  server = "grove1", url = "https://<your-opal>", user = "<user>", password = "<password>",
  table = "<project>.<table>", driver = "OpalDriver",
  profile = "<profile name from step 4>"
)
conns <- DSI::datashield.login(builder$build())
DSI::datashield.pkg_status(conns)
```

---

If running locally and using the default credentials `administrator`/`password`:

```r
library(DSOpal)
builder <- DSI::newDSLoginBuilder()
builder$append(
  server = "grove1", url = "http://localhost:8880", user = "administrator", password = "password",
  table = "CNSIM.CNSIM1", driver = "OpalDriver",
  profile = "GROVE"
)
conns <- DSI::datashield.login(builder$build())
DSI::datashield.pkg_status(conns)
```

## Troubleshooting

| Symptom | Likely cause and fix |
|---|---|
| Browser shows the JSON on `localhost:18085` but Opal does not list grove | Opal is using an address that does not work from its own container. Use step 3. Never `localhost`. |
| Check from inside Opal fails with "could not resolve host" | grove is not on Opal's network (or the alias is missing). Re-run `make connect-opal`. If grove was re-created, the attachment was lost. |
| `connect-opal` says "several running ... containers" | Pass `--opal`, `--grove` and/or `--network` as shown in the message. |
| `connect-opal` says Opal is only on the default bridge network | Docker's default bridge cannot do name resolution. Use Case B (host address) or move Opal to a user-defined network. |
| Rock appears in Apps, but the profile cannot be initialised, or you get 401 | Rock administrator credentials differ from what Opal uses (step 2). |
| Cluster `GROVE` is not offered in Add Profile | The Apps registry has not discovered grove yet: refresh it, and check the Discovery address. |
| Methods of dsGeospatial or dsTidyverse missing in the profile | Re-initialise the profile after rebuilding or recreating grove. |
| `pull access denied` on `make up` | Image not built locally: `make build-image`. |
| `required variable ... is missing` | Copy `.env.example` to `.env` (step 2). |
| Build stops at the package version check | Pass a matching base image: `make build-image rock_base_image=<image>`. |

Useful commands:

```bash
make logs                                   # grove logs
docker logs <opal-container> 2>&1 | grep -i -E 'rock|app|discover'
```

## Make targets

| Target | What it does |
|---|---|
| `make build-image` / `push-image` / `publish` / `remove-image` | Build, push or remove the Docker image |
| `make check` | Print versions of the DataSHIELD packages in the image |
| `make up` / `down` / `stop` / `start` / `restart` / `logs` | Manage grove on its own |
| `make connect-opal` | Attach the running grove to an existing Opal's Docker network (`connect_args="..."` for options) |
| `make disconnect-opal` | Detach it again |
| `make up-opal` | Start grove already joined to Opal's network (needs `OPAL_NETWORK`) |

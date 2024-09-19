# Consolidated devcontainer configs as VPS-like server
- This repo contains working configs that can be used to spin up a server-like environment in your local machine.
- What can you do with it?
	- Isolate development projects as separate containers (think filesystem, environment vars, running process etc.)
	- Create docker containers inside the container itself, (utilizing [docker-in-docker](https://github.com/devcontainers/features/tree/main/src/docker-in-docker) under the hood)
	- Use vs code to SSH to the container like a normal server

- More info on devcontainers [here](https://code.visualstudio.com/docs/devcontainers/containers)


## prequisite
- devcontainer cli `npm install -g @devcontainers/cli`
- docker



## scaffold the devcontainer 
- use followg command to clone & rename the dir to `.devcontainer_prod` which gets referred in the scripts (no need to cd to the repo after cloning)
`git clone https://github.com/luutuankiet/.devcontainer_prod.git .devcontainer_prod` 
- open config at  `.devcontainer_prod/devcontainer.json` and make changes for features i.e.
```json
	"features": {
		"ghcr.io/devcontainers/features/node:1": {
			"nodeGypDependencies": true,
			"installYarnUsingApt": true,
			"version": "lts",
			"nvmVersion": "latest"
		},
		"ghcr.io/devcontainers/features/sshd:1": {
			"version": "latest"
		}
    }
```
- change various container runtime environment per your requirment, e.g 
	- change the name and add some ports to forward. Recommended at least one port if you plan to use the ssh feature later on
	```json
		"runArgs": [
			"--name",
			"PROD_gtd_ETL",
			"-p=60000:60000", // ssh
			"-p=60001:60001" // dagster
		]
	```
	- change persistent env variable in `containerEnv`
	- full list of params and args in [devcontainer doc](https://containers.dev/implementors/json_reference/)


- copy `postCreateCommand_example.sh` to `postCreateCommand.sh` and make changes per your requirement. recommended to keep sections python and zsh setups


- spin up the devcontainer. By default `--workspace-folder` is required which will bind mount current dir to container's `/workspace` dir
 `devcontainer up --config .devcontainer_prod/devcontainer.json --workspace-folder .`
(add `--remove-existing-container` if you want to rebuild)
- clone the repo and unpack to the workspace

## ssh setup
(sshd [feature](https://github.com/devcontainers/features/tree/main/src/sshd) guide.)
- requires this devcontainer config block
```json
		"ghcr.io/devcontainers/features/sshd:1": {
			"version": "latest"
		}
```
- wait for devcontainer successfully spins up then attach shell to it with `docker exec -it PROD_gtd_ETL /bin/bash` (`PROD_gtd_ETL` be the container name defined earlier)
- `passwd` and change the root password
- `vim /etc/ssh/sshd.config` and update the port value to the desired port e.g. 60000
- `/etc/init.d/ssh restart` to restart the ssh server
- `ssh -p 60000 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null root@<machine_ip>`k
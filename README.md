# ctr_ansible_ubuntu24

Ubuntu 24.04 (Noble Numbat) Docker container for Ansible playbook and role testing with [Molecule](https://molecule.readthedocs.io/).

## Description

This container is based on `ubuntu:24.04` and includes:

- **systemd** – enables testing of services that rely on systemd init
- **Ansible** – installed via pip for running playbooks and roles
- Supporting libraries: `python3`, `libffi-dev`, `libssl-dev`, `libyaml-dev`, and more

It is intended to be used as a target container for Molecule-based Ansible role testing.

## Usage

### Pull the image

```bash
docker pull ghcr.io/bnlcyber/ctr_ansible_ubuntu24:latest
```

### Run interactively

```bash
docker run --rm -it --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
  ghcr.io/bnlcyber/ctr_ansible_ubuntu24:latest
```

### Use with Molecule

In your `molecule.yml`, configure the driver to use this image as the platform:

```yaml
platforms:
  - name: instance
    image: ghcr.io/bnlcyber/ctr_ansible_ubuntu24:latest
    command: /lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    privileged: true
```

## Building locally

```bash
docker build -t ctr-ansible-ubuntu24 .
```

## License

MIT – see [LICENSE](LICENSE).

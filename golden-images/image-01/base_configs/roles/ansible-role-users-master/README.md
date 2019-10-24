# users

[![Build Status](https://travis-ci.com/iroquoisorg/ansible-role-users.svg?branch=master)](https://travis-ci.com/iroquoisorg/ansible-role-users)

Ansible role for users

This role was prepared and tested for Ubuntu 16.04.

# Installation

`$ ansible-galaxy install iroquoisorg.users`

# Default settings

```
---
administration_users: []
local_users: []
local_groups: []
users_env_var_prefix: ""
ci_build: false
```

# Development

Please check [development guide](DEVELOPMENT.md) for details about developing and testing this role.

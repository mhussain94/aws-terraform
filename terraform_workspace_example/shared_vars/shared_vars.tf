locals {
    env = "${terraform.workspace}"

    env_suffix_env = { #map of values
        default = "staging"
        staging = "staging"
        production = "production"

    }

    env_suffix = "${lookup(local.env_suffix_env, local.env)}" # compares with the map of amiids and the env variable
}

output "env_suffix" {
    value = "${local.env_suffix}"
}
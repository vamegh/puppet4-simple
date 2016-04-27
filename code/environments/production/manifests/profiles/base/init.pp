
class profiles::base {
  Host <| |> -> Yumrepo <| |> -> Package <| |>
  class {'banner':}

  ## Pull in all repos from hiera that are using base_repos as their container key
  $base_repos = hiera_hash('base_repos',{})
  if !empty($base_repos) {
    create_resources('yum_repo::add_repo', $base_repos)
  }

 $base_packages = hiera_hash('base_packages',{})
  if !empty($base_packages) {
    create_resources('generic_tools::add_packages', $base_packages)
  }

  $base_paths = hiera_hash('base_paths',{})
  if !empty($base_paths) {
    create_resources('generic_tools::add_paths', $base_paths)
  }

  $env_vars = hiera_hash('env_vars',{})
  if !empty($env_vars) {
    create_resources('generic_tools::setenv',$env_vars)
  }

  $base_groups = hiera_hash('base_groups',{})
  if !empty($base_groups) {
    create_resources('generic_tools::add_groups', $base_groups)
  }

  $ip_pre_chains = hiera_hash('ip_pre_chains',{})
  if !empty($ip_pre_chains) {
    create_resources('firewallchain', $ip_pre_chains)
  }

  $ip_rules = hiera_hash('ip_rules',{})
  if !empty($ip_rules) {
    create_resources('firewall', $ip_rules)
  }

  $ip_post_chains = hiera_hash('ip_post_chains',{})
  if !empty($ip_post_chains) {
    create_resources('firewallchain', $ip_post_chains)
  }
}



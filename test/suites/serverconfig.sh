test_server_config() {
  LXD_SERVERCONFIG_DIR=$(mktemp -d -p ${TEST_DIR} XXX)
  spawn_lxd 127.0.0.1:18450 ${LXD_SERVERCONFIG_DIR}

  lxc config set core.trust_password 123456

  config=$(lxc config show)
  echo ${config} | grep -q "trust_password"
  echo ${config} | grep -q -v "123456"

  lxc config unset core.trust_password
  lxc config show | grep -q -v "trust_password"

  # test untrusted server GET
  my_curl -X GET https://127.0.0.1:18450/1.0 | grep -v -q environment
}

import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_user_is_created(host):
    passwd = host.file('/etc/passwd')

    assert passwd.contains("john")


def test_user_information(host):
    assert host.user('john').uid
    assert host.user('john').home
    assert host.user('john').shell

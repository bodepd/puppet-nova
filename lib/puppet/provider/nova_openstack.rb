require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/credentials'
class Puppet::Provider::NovaOpenstack < Puppet::Provider::Openstack

  def self.nova_request(service, action, properties=[], credentials=credentials)
    request(service, action, properties, credentials)
  end

  def self.credentials
    credentials = {
      'tenant_name'  => get_admin_tenant,
      'project_name' => get_admin_tenant,
      'username'     => get_admin_user,
      'password'     => get_admin_pass,
      'auth_url'     => get_auth_uri,
    }
    raise error unless (credentials['tenant_name'] && credentials['auth_url'] && credentials['username'] && credentials['password'])
    creds = Puppet::Provider::Openstack::CredentialsV3.new
    credentials.each do |x, v|
      creds.set(x, v)
    end
    creds
  end

  def self.admin_tenant
    @admin_tenant ||= get_admin_tenant
  end

  def self.get_admin_tenant
    if nova_file and nova_file['keystone_authtoken'] and nova_file['keystone_authtoken']['admin_tenant_name']
      return "#{nova_file['keystone_authtoken']['admin_tenant_name'].strip}"
    else
      return nil
    end
  end

  def self.admin_user
    @admin_user ||= get_admin_user
  end

  def self.get_admin_user
    if nova_file and nova_file['keystone_authtoken'] and nova_file['keystone_authtoken']['admin_user']
      return "#{nova_file['keystone_authtoken']['admin_user'].strip}"
    else
      return nil
    end
  end

  def self.admin_pass
    @admin_pass ||= get_admin_pass
  end

  def self.get_admin_pass
    if nova_file and nova_file['keystone_authtoken'] and nova_file['keystone_authtoken']['admin_password']
      return "#{nova_file['keystone_authtoken']['admin_password'].strip}"
    else
      return nil
    end
  end

  def self.auth_uri
    @auth_uri ||= get_auth_uri
  end

  def self.get_auth_uri
    if nova_file and nova_file['keystone_authtoken'] and nova_file['keystone_authtoken']['auth_uri']
      return "#{nova_file['keystone_authtoken']['auth_uri'].strip}"
    else
      return nil
    end
  end

  def self.nova_file
    return @nova_file if @nova_file
    @nova_file = Puppet::Util::IniConfig::File.new
    @nova_file.read('/etc/nova/nova.conf')
    @nova_file
  end

end


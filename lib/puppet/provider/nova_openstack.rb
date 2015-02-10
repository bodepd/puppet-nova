require 'puppet/util/inifile'
require 'puppet/provider/openstack'
class Puppet::Provider::NovaOpenstack < Puppet::Provider::Openstack

  def request(service, action, object, credentials, *properties)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError => error
      nova_request(service, action, object, credentials, error, *properties)
    end
  end

  def self.request(service, action, object, credentials, *properties)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError => error
      nova_request(service, action, object, credentials, error, *properties)
    end
  end

  def nova_request(service, action, object, credentials, error, *properties)
    self.class.nova_request(service, action, object, credentials, error, *properties)
  end

  def self.nova_request(service, action, object, credentials, error, *properties)
    credentials = {
      'tenant_name' => get_admin_tenant,
      'username'    => get_admin_user,
      'password'    => get_admin_pass,
      'auth_url'    => get_auth_uri,
    }
    raise error unless (credentials['tenant_name'] && credentials['auth_url'] && credentials['username'] && credentials['password'])
    auth_args = password_auth_args(credentials)
    args = [object, properties, auth_args].flatten.compact.reject(&:empty?)
    authenticate_request(service, action, args)
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

  def get_admin_tenant
    self.class.get_admin_tenant
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

  def get_admin_user
    self.class.get_admin_user
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

  def get_admin_pass
    self.class.get_admin_pass
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

  def get_auth_uri
    self.class.get_auth_uri
  end

  def self.nova_file
    return @nova_file if @nova_file
    @nova_file = Puppet::Util::IniConfig::File.new
    @nova_file.read('/etc/nova/nova.conf')
    @nova_file
  end

  def nova_file
    self.class.nova_file
  end
end


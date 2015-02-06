require 'puppet/util/openstack'

Puppet::Type.newtype(:nova_flavor) do

  @doc = "Manage creation/deletion of nova flavor."

  ensurable

  newparam(:name, :namevar => true) do
    desc "flavor name"
    newvalues(/\S/)
  end

  newproperty(:ephemeral) do
    newvalues(/\d/)
    desc "Ephemeral disk in GB"
    munge do |value|
      value.to_s.strip
    end
  end

  newproperty(:disk) do
    newvalues(/\d/)
    desc 'root disk size in GB'
    munge do |value|
      value.to_s.strip
    end
  end

  newproperty(:swap) do
    newvalues(/\d/)
    desc 'Swap size in GB'
    munge do |value|
      value.to_s.strip
    end
  end

  newproperty(:rxtx) do
    desc 'Network RXTX Factor'
    munge do |value|
      value.to_s.strip
    end
  end

  newproperty(:public) do
    desc 'Is this flavor public'
    defaultto(true)
    munge do |value|
      value.to_s.strip.capitalize
    end
  end

  newproperty(:ram) do
    newvalues(/\d/)
    desc 'RAM Size in GB'
    munge do |value|
      value.to_s.strip
    end
  end

  newproperty(:vcpu) do
    newvalues(/\d/)
    desc 'Number of VCPUs'
    munge do |value|
      value.to_s.strip
    end
  end

  validate do
    raise(Puppet::Error, 'RAM must be set') unless self[:ram]
    raise(Puppet::Error, 'VCPU must be set') unless self[:vcpu]
    raise(Puppet::Error, 'Disk size must be set') unless self[:disk]
  end

auth_param_doc=<<EOT
  keystone authentication details
EOT
  Puppet::Util::Openstack.add_openstack_type_methods(self, auth_param_doc)

end

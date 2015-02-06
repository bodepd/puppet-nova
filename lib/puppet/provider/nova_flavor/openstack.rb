require 'puppet/provider/openstack'

Puppet::Type.type(:nova_flavor).provide(
  :openstack,
  :parent => Puppet::Provider::Openstack
) do

  desc "Provider to manage nova flavors"

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def properties
    if ! @properties
      @properties = []
      if resource[:ram]
        properties << '--ram'
        properties << resource[:ram]
      end
      if resource[:disk]
        properties << '--disk'
        properties << resource[:disk]
      end
      if resource[:vcpu]
        properties << '--vcpu'
        properties << resource[:vcpu]
      end
    end
    return @properties
  end

  def create
    request('flavor', 'create', resource[:name], resource[:auth], properties)
  end

  def exists?
    ! instance(resource[:name]).empty?
  end

  def destroy
    request('flavor', 'delete', resource[:name], resource[:auth])
  end

  def reset
    destroy
    create
  end

  def disk
    instance(resource[:name])[:disk]
  end

  def disk=(value)
    reset
  end

  def public
    instance(resource[:name])[:public]
  end

  def public=(value)
    reset
  end

  def ram
    instance(resource[:name])[:ram]
  end

  def ram=(value)
    reset
  end

  def vcpu
    instance(resource[:name])[:vcpu]
  end

  def vcpu=(value)
    reset
  end

  def swap
    instance(resource[:name])[:swap]
  end

  def swap=(value)
    reset
  end

  def ephemeral
    instance(resource[:name])[:ephemeral]
  end

  def ephemeral=(value)
    reset
  end

  def rxtx
    instance(resource[:name])[:rxtx]
  end

  def rxtx=(value)
    reset
  end


  def id
    instance(resource[:name])[:id]
  end

  def self.instances
    list = request('flavor', 'list', nil, nil, '')
    list.collect do |flavor|
      new(
        :name      => flavor[:name],
        :ensure    => :present,
	:ram	   => flavor[:ram],
	:disk	   => flavor[:disk],
	:vcpu	   => flavor[:vcpus],
        :ephemeral => flavor[:ephemeral],
        :swap      => flavor[:swap],
        :rxtx      => flavor[:rxtx],
        :public    => flavor[:is_public],
      )
    end
  end

  def instances
    instances = request('flavor', 'list', nil, resource[:auth], '')
    instances.collect do |flavor|
      {
        :name      => flavor[:name],
        :ensure    => :present,
        :ram       => flavor[:ram],
        :disk      => flavor[:disk],
        :ephemeral => flavor[:ephemeral],
        :swap      => flavor[:swap],
        :rxtx      => flavor[:rxtx],
        :vcpu      => flavor[:vcpus],
        :public    => flavor[:is_public],
      }
    end
  end

  def instance(name)
    @instances ||= instances.select { |instance| instance[:name] == name }.first || {}
  end

end

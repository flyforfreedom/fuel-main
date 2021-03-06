Puppet::Type.newtype(:mongodb_user) do
  @doc = 'Manage a MongoDB user. This includes management of users password as well as privileges.'

  ensurable

  def initialize(*args)
    super
    # Sort roles array before comparison.
    self[:roles] = Array(self[:roles]).sort!
  end

  newparam(:name, :namevar=>true) do
    desc "The name of the user."
  end

  newparam(:admin_username) do
    desc "Administrator user login"
    defaultto 'admin'
  end

  newparam(:admin_password) do
    desc "Administrator user password"
  end

  newparam(:admin_host) do
    desc "Connect to this host as an admin user"
    defaultto 'localhost'
  end

  newparam(:admin_port) do
    desc "Connect to this port as an admin user"
    defaultto '27017'
  end

  newparam(:mongo_path) do
    desc "Path to mongo binary"
    defaultto '/usr/bin/mongo'
  end

  newparam(:admin_database) do
    desc "Connect to this database as an admin user"
    defaultto 'admin'
  end

  newparam(:database) do
    desc "The user's target database."
    defaultto do
      fail("Parameter 'database' must be set")
    end
    newvalues(/^\w+$/)
  end

  newparam(:tries) do
    desc "The maximum amount of two second tries to wait MongoDB startup."
    defaultto 10
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:roles, :array_matching => :all) do
    desc "The user's roles."
    defaultto ['dbAdmin']
    newvalue(/^\w+$/)

    # Pretty output for arrays.
    def should_to_s(value)
      value.inspect
    end

    def is_to_s(value)
      value.inspect
    end
  end

  newproperty(:password_hash) do
    desc "The password hash of the user. Use mongodb_password() for creating hash."
    defaultto do
      fail("Property 'password_hash' must be set. Use mongodb_password() for creating hash.")
    end
    newvalue(/^\w+$/)
  end

  autorequire(:package) do
    'mongodb'
  end

  autorequire(:service) do
    'mongodb'
  end
end

#
# NXAPI implementation of BFD Global class
#
# May 2016, Sai Chintalapudi
#
# Copyright (c) 2016 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'node_util'

module Cisco
  # node_utils class for bfd_global
  class BfdGlobal < NodeUtil
    attr_reader :name

    def initialize(instantiate=true)
      set_args_keys_default

      Feature.bfd_enable if instantiate
    end

    # Reset everything back to default
    def destroy
      return unless Feature.bfd_enabled?
      self.echo_interface = default_echo_interface
      self.fabricpath_vlan = default_fabricpath_vlan if fabricpath_vlan
      self.startup_timer = default_startup_timer if startup_timer
      set_args_keys_default
    end

    # Helper method to delete @set_args hash keys
    def set_args_keys_default
      keys = { state: '' }
      @get_args = @set_args = keys
    end

    # rubocop:disable Style/AccessorMethodName
    def set_args_keys(hash={})
      set_args_keys_default
      @set_args = @get_args.merge!(hash) unless hash.empty?
    end

    ########################################################
    #                      PROPERTIES                      #
    ########################################################

    def echo_interface
      config_get('bfd_global', 'echo_interface', @get_args)
    end

    def echo_interface=(val)
      set_args_keys(intf:  val ? val : echo_interface,
                    state: val ? '' : 'no')
      config_set('bfd_global', 'echo_interface', @set_args) if
        @set_args[:intf]
    end

    def default_echo_interface
      config_get_default('bfd_global', 'echo_interface')
    end

    def startup_timer
      config_get('bfd_global', 'startup_timer', @get_args)
    end

    def startup_timer=(val)
      set_args_keys(timer: val,
                    state: val == default_startup_timer ? 'no' : '')
      config_set('bfd_global', 'startup_timer', @set_args)
    end

    def default_startup_timer
      config_get_default('bfd_global', 'startup_timer')
    end

    def fabricpath_vlan
      config_get('bfd_global', 'fabricpath_vlan', @get_args)
    end

    def fabricpath_vlan=(val)
      set_args_keys(vlan:  val,
                    state: val == default_fabricpath_vlan ? 'no' : '')
      config_set('bfd_global', 'fabricpath_vlan', @set_args)
    end

    def default_fabricpath_vlan
      config_get_default('bfd_global', 'fabricpath_vlan')
    end
  end # class
end # module
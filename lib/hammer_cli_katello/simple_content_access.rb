module HammerCLIKatello
  class SimpleContentAccess < HammerCLIKatello::Command
    desc "Toggle simple content access mode across organization"

    module EligibleCheck
      include ApipieHelper
      def request_params
        super.tap do |opts|
          unless call(:eligible, :simple_content_access, opts)["simple_content_access_eligible"]
            raise _("This organization is not eligible for Simple Content Access")
          end
        end
      end
    end

    class EnableCommand < HammerCLIKatello::SingleResourceCommand
      include EligibleCheck
      resource :simple_content_access, :enable
      command_name "enable"

      success_message _("Simple Content Access Enabled.")
      failure_message _("Could not enable Simple Content Access for this organization")

      build_options
    end

    class DisableCommand < HammerCLIKatello::SingleResourceCommand
      include EligibleCheck
      resource :simple_content_access, :disable
      command_name "disable"

      success_message _("Simple Content Access Disabled.")
      failure_message _("Could not disable Simple Content Access for this organization")

      build_options
    end

    autoload_subcommands
  end
end

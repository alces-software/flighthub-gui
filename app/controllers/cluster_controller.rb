class ClusterController < ApplicationController
  def index
    #BoltOns
    @vpn = {
      enabled: bolt_on_enabled('VPN'),
      status: vpn_status,
      name: vpn_name[0]
    }

    @content = appliance_information
  end

  def restart
    if run_global_script(ENV['POWER_RESTART'])[2].success?
      flash[:success] = 'Restarting machine'
    else
      flash[:danger] = 'Encountered an error whilst trying to restart the machine'
    end

    redirect_to cluster_path
  end

  def stop
    if run_global_script(ENV['POWER_OFF'])[2].success?
      flash[:success] = 'Stopping the machine'
    else
      flash[:danger] = 'Encountered an error whilst trying to stop the machine'
    end

    redirect_to cluster_path
  end

  private

  def appliance_information
    file = Rails.application.config.appliance_information
    file_data = IO.binread(file) if File.exist? file

    if file_data
      render_as_markdown(file_data)
    end
  end

  def vpn_status
    run_global_script(ENV['VPN_STATUS'])[2].success?
  end

  def vpn_name
    run_global_script(ENV['VPN_NAME'])
  end
end

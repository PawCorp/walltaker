module LinksHelper
  def link_id_for_decoration(link_id)
    return '🐇' if link_id == 69
    return '🐺' if link_id == 666 || link_id == 343
    return '🐕' if link_id == 1
    return '🐈' if link_id == 658 || link_id == 656
    return '🥎' if link_id == 348
    return '⚙️' if link_id == 581
    return '🏳️‍🌈' if link_id == 346
    return '🦊' if link_id == 1964

    link_id
  end

  def link_agent_to_icon(link_agent)
    return :unknown if link_agent.nil?
    return :desktop if link_agent.include? 'Walltaker Go Client/'
    return :android if link_agent.include? 'walltaker-android-client/'
    return :joihow if link_agent.include? 'joihow'
    return :wallpaper_engine if link_agent.include? 'Wallpaper-Engine-Client'
    return :automate if link_agent.include? 'walltaker-android-automate'
    return :arson_automate if link_agent.include? 'arson-walltaker-automate'
    return :ioswidget if link_agent.include? 'widgetExtension'
    return :swift if link_agent.include? 'CFNetwork/'
    return :android_changer if link_agent.include? 'Walltaker-Changer/'
    return :jberliner if link_agent.include? 'JBerliner'

    :unknown
  end
end

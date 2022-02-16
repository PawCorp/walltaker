module LinksHelper
  def link_id_for_decoration(link_id)
    return '🐇' if link_id == 8
    return '🐕' if link_id == 1
    link_id
  end
end

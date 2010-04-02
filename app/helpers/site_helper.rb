module SiteHelper
  def tiering path, sep
    tier = []
    path.each_index do |i|
      tier << [path[i], path[0,i + 1].join('/')]
    end
    tier.unshift ['root', '']
    tier.map {|t| link_to t[0], '/' + t[1] }.join(sep)
  end
end

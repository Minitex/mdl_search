class CrawlerDetector
  BOT_USER_AGENT = /bot|Bot/
  private_constant :BOT_USER_AGENT

  def self.call(req)
    req.env['HTTP_USER_AGENT'] =~ BOT_USER_AGENT
  end
end

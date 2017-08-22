module GithubNotify
  class Comment

    API_GITHUB_ROOT = "https://api.github.com"

    def initialize(token:, url: nil, owner: nil, repository: nil, number: nil, body:)
      @token      = token         # Set token
      @url        = url           # Full URL ex. https://api.github.com/repos/YOUR_NAME/REPOSITORY_NAME/issues/1/comments
      @owner      = owner         # Your Name or Organization
      @repository = repository    # Your Repository
      @number     = number        # PR Number
      @body       = body          # GitHub Markdown Text
    end

    def post
      @url ||= "#{API_GITHUB_ROOT}/repos/#{@owner}/#{@repository}/issues/#{@number}/comments"
      uri = URI.parse(@url)

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri)

      if @token.nil?
        p "Not setting token."
        return
      end
      req["Authorization"] = "token #{@token}"

      if @body.nil?
        p "Not setting comment."
        return
      end
      query = {body: @body}

      req.body = query.to_json
      https.request(req)
    end

  end
end


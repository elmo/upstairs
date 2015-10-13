module Attachinary
  module Utils
    # Don't raise errors on the presence of the following attributes in params:
    #   :signature, :created_at, :bytes, :type, :etag, :url, :secure_url, :tags, :pages
    def self.process_hash(hash, scope = nil)
      if hash['id']
        Attachinary::File.find hash['id']
      else
        file = if Rails::VERSION::MAJOR == 3
                 Attachinary::File.new hash.slice(*Attachinary::File.attr_accessible[:default].to_a)
               else
                 # this line added:
                 hash.except!('signature', 'created_at', 'bytes', 'type', 'etag', 'url', 'secure_url', 'tags', 'pages')
                 permitted_params = ActionController::Parameters.new(hash).permit(:public_id, :version, :width, :height, :format, :resource_type)
                 Attachinary::File.new(permitted_params)
        end
        file.scope = scope.to_s if scope && file.respond_to?(:scope=)
        file
      end
    end
  end
end

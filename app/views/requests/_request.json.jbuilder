json.extract! request, :id, :uid, :ip, :method, :url, :parameters, :created_at, :updated_at
json.url request_url(request, format: :json)

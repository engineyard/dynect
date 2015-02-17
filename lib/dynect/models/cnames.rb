class Dynect::Cnames < Cistern::Collection
  include Collection

  model Dynect::Client::Cname

  model_root "cname"
  model_request :get_cname
end

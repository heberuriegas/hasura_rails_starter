class CreateDirectUpload < HasuraHandler::Action
  action_name :create_direct_upload

  def run
    blob_args = @input['object']
    blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args.symbolize_keys)
    @output = {
      direct_upload: {
        url: Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true),
        headers: blob.service_headers_for_direct_upload.to_json,
        blob_id: blob.id,
        signed_blob_id: blob.signed_id
      }
    }
  end
end

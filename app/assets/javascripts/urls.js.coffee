window.photo_comments_path = (params) ->
  "/photos/#{params.photo_id}/comments"

window.photo_plus_ones_path = (params) ->
  "/photos/#{params.photo_id}/plus_ones"

window.admin_edit_photo_path = (params) ->
  "/admin/photos/#{params.photo_id}/edit"

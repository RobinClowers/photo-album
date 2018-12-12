class MigratePhotoVersions
  def self.execute
    Photo.connection.execute(
      <<-SQL
      INSERT INTO photo_versions(size, mime_type, width, height, photo_id, created_at, updated_at)
      SELECT 'web', mime_type, width, height, id, current_timestamp, current_timestamp
      FROM photos
      WHERE photos.versions @> '{web}';

      INSERT INTO photo_versions(size, mime_type, width, height, photo_id, created_at, updated_at)
      SELECT 'small', mime_type, width, height, id, current_timestamp, current_timestamp
      FROM photos
      WHERE photos.versions @> '{small}';

      INSERT INTO photo_versions(size, mime_type, width, height, photo_id, created_at, updated_at)
      SELECT 'original', mime_type, width, height, id, current_timestamp, current_timestamp
      FROM photos
      WHERE photos.versions @> '{original}';

      INSERT INTO photo_versions(size, mime_type, width, photo_id, height, created_at, updated_at)
      SELECT 'thumb', mime_type, width, height, id, current_timestamp, current_timestamp
      FROM photos
      WHERE photos.versions @> '{thumbs}';
      SQL
    )
  end
end

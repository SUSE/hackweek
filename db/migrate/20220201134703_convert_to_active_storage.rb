class ConvertToActiveStorage < ActiveRecord::Migration[7.0]
  require 'open-uri'

  def up
    models = [Project, Keyword]
    transaction do
      models.each do |model|
        model.find_each.each do |instance|
          next if instance.send('avatar_file_name').blank?
	  puts "converting #{instance.class.name} with id #{instance.id}"
          blob = ActiveStorage::Blob.create(key: SecureRandom.uuid,
                                            filename: instance.send('avatar_file_name'),
                                            content_type: instance.send('avatar_content_type'),
                                            metadata: {},
                                            service_name: 'local',
                                            byte_size: instance.send('avatar_file_size'),
                                            checksum: Digest::MD5.base64digest(File.read(instance.avatar.path)))
          attachment = ActiveStorage::Attachment.create(name: 'avatar',
                                                        record_type: model.name,
                                                        record_id: instance.id,
                                                        blob_id: blob.id)
          source = attachment.record.send('avatar').path
          dest_dir = File.join(
            'storage',
            attachment.blob.key.first(2),
            attachment.blob.key.first(4).last(2)
          )
          dest = File.join(dest_dir, attachment.blob.key)

          FileUtils.mkdir_p(dest_dir)
          puts "Moving #{source} to #{dest}"
          FileUtils.cp(source, dest)
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::Meta
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  def default_url
    "/assets/" + [version_name, "default_avatar.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end
  version :crop do
    process :crop_to => [200, 200]
  end
  version :mini do
    process :crop_to => [32, 32]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "dame09plus-#{mounted_as}-#{model.id}.#{file.extension}" if original_filename
  end


  
  model_delegate_attribute :x
  model_delegate_attribute :y
  model_delegate_attribute :w
  model_delegate_attribute :h

  # Crop processor
  def crop_to(width, height)
    # Checks that crop area is defined and crop should be done.
    if ((crop_args[0] == crop_args[2]) || (crop_args[1] == crop_args[3]))
      # If not creates default image and saves it's dimensions.
      resize_to_fill_and_save_dimensions(width, height)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end
  end

  def crop_and_resize(x, y, width, height, new_width, new_height)
    manipulate! do |img|
      cropped_img = img.crop(x, y, width, height)
      new_img = cropped_img.resize_to_fill(new_width, new_height)
      destroy_image(cropped_img)
      destroy_image(img)      
      new_img
    end
  end

  # Creates the default crop image.
  # Here the original crop area dimensions are restored and assigned to the model's instance.  
  def resize_to_fill_and_save_dimensions(new_width, new_height)
    manipulate! do |img|
      width, height = img.columns, img.rows
      new_img = img.resize_to_fill(new_width, new_height)
      destroy_image(img)

      w_ratio = width.to_f / new_width.to_f
      h_ratio = height.to_f / new_height.to_f

      ratio = [w_ratio, h_ratio].min

      self.w = ratio * new_width
      self.h = ratio * new_height
      self.x = (width - self.w) / 2
      self.y = (height - self.h) / 2

      new_img
    end
  end

  private
  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end
end

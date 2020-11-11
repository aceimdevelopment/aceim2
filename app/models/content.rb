class Content < ApplicationRecord

  validates :title, presence: true
  has_one_attached :file
  attr_accessor :remove_file
  after_save { file.purge if remove_file.eql? '1' }

  before_save :youtube_embed

  scope :published, -> {where(published: true)}

  enum category: [:videos, :imagenes, :archivos]

  rails_admin do

    list do
      field :title do
        label 'Título'
      end
      field :description do
        label 'Descripción'
      end
      field :category do
        label 'Categoría'
      end
      field :published do
        label 'Publicar'
      end
      field :url do
      end
      field :file do
        label 'Imagen Adjunta'
      end      
      exclude_fields :created_at, :updated_at
    end
    show do
      field :title do
        label 'Título'
      end
      field :description do
        label 'Descripción'
      end
      field :category do
        label 'Categoría'
      end
      field :published do
        label 'Publicar'
      end
      field :url do
      end
      field :file, :active_storage do
        label 'Imagen Adjunta'
        delete_method :remove_file
      end
    end
    edit do
      field :title do
        label 'Título'
      end
      field :description do
        label 'Descripción'
      end
      field :category do
        label 'Categoría'
      end
      field :url do
      end
      field :file, :active_storage do
        label 'Imagen Adjunta'
        delete_method :remove_file
      end
      field :published do
        label 'Publicar'
      end
    end
  end

  protected

  def youtube_embed

    if (self.url and self.url.include? 'youtu' and !self.url.include? 'embed')
      youtube_id = (url.split('/')).last
      self.url = "https://www.youtube.com/embed/#{youtube_id}"
    end
  end
end

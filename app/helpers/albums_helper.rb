module AlbumsHelper

  def generate_back_link(album, picture)

    out = ''

    if !cookies[:page].blank?
      out << link_to('Zurück', album_path(album, anchor: "#{dom_id picture}", page: cookies[:page]), class: 'btn btn-primary')
    else
      out << link_to('Zurück', album_path(album, anchor: "#{dom_id picture}"), class: 'btn btn-primary')
    end

    out.html_safe
  end

end

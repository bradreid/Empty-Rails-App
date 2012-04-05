module LinkHelper
  
  def listing_link(path, opts = {})
    alt_text = opts[:title].blank?? 'Back to Listing' : opts[:title]
    link_to(image_tag('link_icons/list.png', :alt => alt_text, :align => 'middle'), path, {:title => 'Back to Listing'}.merge(opts))
  end

  def view_link(path, opts = {})
    link_to(image_tag('link_icons/view.png', :alt => 'View', :height => 25, :align => 'middle', :style => 'height:25px'), path, {:title => 'View'}.merge(opts))
  end

  def edit_link(path, opts = {})
    link_to(image_tag('link_icons/edit.png', :alt => 'Edit', :align => 'middle'), edit_polymorphic_path(path), {:title => 'Edit'}.merge(opts))
  end

  def delete_link(*args)
    path         = args.first || {}
    html_options = {
                    :method   => :delete,
                    :confirm  => "Are you sure? Clicking 'OK' will remove this record permanently!",
                    :title    => "Delete",
                    :alt_text => "Delete"
                    }
                    
    html_options.merge!(args.second) if args.second
    name   = html_options.delete(:name) || "Delete"
    img_tg = image_tag('link_icons/delete.png', :alt => html_options[:alt_text], :title => html_options[:title], :align => 'middle').html_safe
    remote = html_options.delete(:remote)
    bttn   = html_options.delete(:button)
    if remote && bttn
      submit_to_remote(html_options[:alt_text], html_options[:alt_text], html_options.merge({:url => path}))
    elsif remote
      link_to_remote(img_tg, html_options.merge({:url => path, :loading => "$(this).parent().spin();"}))
    else
      link_to(img_tg, path, html_options)
    end
  end

  
  def context_index(context)
    # note: we want this to blow up if (NOT lineage.last.is_a? Symbol)
    index_symbol = context.last.class.name.pluralize.underscore.to_sym
    a = context.compact[0..-2] << index_symbol
    is_all_symbols = a.map {|item| item.is_a?(Symbol)}.all?
    a = is_all_symbols ? a.join('_') : a
    a
  end  
  
  def index_link_title(index_offset, context)
    if index_offset == -1
      "View " + context.last.class.name.underscore.pluralize.humanize
    else
      "View " + context[0..index_offset].last.class.name.underscore.humanize
    end
  end
  
  def action_images(context, opts ={})
    context = lineage unless context
    index_offset = -((opts[:index_offset] || 0) +1)
    options = {:index => {:title => index_link_title(index_offset, context)}.merge(opts[:index] || {}), :exclude => []}.merge((opts || {}))    
    index_path = index_offset == -1 ? context_index(context) : context[0..index_offset] unless options[:exclude].include?(:index)
    a = []
    a << [listing_link(opts[:index_path] || polymorphic_path(index_path), options.merge(options[:index] || {}))] unless options[:exclude].include?(:index)
    a << [ view_link(context, options.merge(options[:show] || {}))] unless options[:exclude].include?(:show)
    a << [ edit_link(context, options.merge(options[:edit] || {}))] unless options[:exclude].include?(:edit)
    a << [ delete_link(context, options.merge(options[:delete] || {}))] unless options[:exclude].include?(:delete) 
    a.flatten.compact.join( ' | ').html_safe
  end
  
  def delete_link_text(context, new_opts = {}, path_opts = {})
    opts = {:title => 'Delete', :method => :delete,
           :confirm  => "Are you sure? Clicking 'OK' will remove this record permanently!",
           :alt_text => "Delete"}.merge(new_opts)        
    link_to(opts[:title], polymorphic_path(context, path_opts), opts)
  end  
  
  def view_link_text(context, new_opts = {}, path_opts = {})
    opts = {:title => 'View'}.merge(new_opts)        
    link_to(opts[:title], polymorphic_path(context, path_opts), opts)
  end
  
  
  def edit_link_text(context, new_opts = {}, path_opts = {})
    opts = {:title => 'Edit'}.merge(new_opts)
    link_to(opts[:title], edit_polymorphic_path(context, path_opts), opts)
  end  

  
  def action_links(context, opts = {})
    context = lineage unless context
    index_offset = -((opts[:index_offset] || 0) +1)
    options = {:index => {:title => index_link_title(index_offset, context)}.merge(opts[:index] || {}), :exclude => []}.merge((opts || {}))    
    index_path = index_offset == -1 ? context_index(context) : context[0..index_offset] unless options[:exclude].include?(:index)
    a = []
    a << [link_to(options[:index][:title], opts[:index_path] || polymorphic_path(index_path))] unless options[:exclude].include?(:index)
    a << [ view_link_text(context, options.merge(options[:show] || {}))] unless options[:exclude].include?(:show)
    a << [ edit_link_text(context, options.merge(options[:edit] || {}))] unless options[:exclude].include?(:edit)
    a << [ delete_link_text(context, options.merge(options[:delete] || {}))] unless options[:exclude].include?(:delete) 
    a.flatten.compact.join( ' | ').html_safe
  end
  
  def exclude_actions(exclude=nil)
    if ['edit', 'show'].include?(params[:action])
      ([params[:action].to_sym] + (exclude || [])).uniq
    else
      exclude || []
    end
  end

end
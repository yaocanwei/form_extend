require "form_extend/version"
require "form_extend/formbuilder_extend"

module FormExtend
  def labelled_form_for(*args, &proc)
    args << {} unless args.last.is_a?(Hash)
    options = args.last
    if args.first.is_a?(Symbol)
      options.merge!(:as => args.shift)
    end
    options.merge!({:builder => FormExtend::FormbuilderExtend})
    form_for(*args, &proc)
  end
end

ActionView::Base.send :include, FormExtend
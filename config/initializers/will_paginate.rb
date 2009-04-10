options = {}
options[:prev_label] = I18n.t('pagination.prev_label')
options[:next_label] = I18n.t('pagination.next_label')

WillPaginate::ViewHelpers.pagination_options.update options

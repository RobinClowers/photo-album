RunLoop.register ->
  $('.tooltip').not('.tooltipstered').each ->
    $(this).tooltipster
      position: $(this).data('tooltip-position') || 'top'

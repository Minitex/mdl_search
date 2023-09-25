$(document).ready(function () {
  $(".advanced-search-facet-select").chosen({
    placeholder_text_multiple: "Select...",
    single_backstroke_delete: false,
    inherit_select_classes: true
  });

  $(".advanced-search-field .range_begin, .advanced-search-field .range_end").on('input', function (e) {
    e.target.value = e.target.value.replaceAll(/[^0-9]/g, '');
    var $inputs = $(".advanced-search-field .range_begin, .advanced-search-field .range_end");
    $('.date-range-error-message').hide();
    $inputs.removeClass('has-error');
    $("form.advanced input[type='submit']").prop('disabled', false);
  });

  $("form.advanced").on('submit', function (e) {
    var $begin = $(this).find(".range_begin");
    var $end = $(this).find(".range_end");

    var startDate = Number($begin.val());
    var endDate = Number($end.val());

    if (endDate < startDate) {
      e.preventDefault();
      $begin.addClass('has-error');
      $end.addClass('has-error');
      $('.date-range-error-message').show();
    }
  });
})

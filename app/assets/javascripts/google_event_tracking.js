$( document ).on('turbolinks:load', function() {

  function serialize_event_value(data) {
    return data + '|' + window.location.hostname + '|' + window.location.pathname
  }

  function ga_event(category, action, label) {
    ga('send', {
      hitType: 'event',
      eventCategory: category,
      eventAction:  action,
      eventLabel: serialize_event_value(label)
    });
  }

  // FULL RECORD ACTIONS
  $('.blacklight-catalog-show').each(function() {
    var metadata = JSON.parse($('.metadata').attr('data-metadata'));
    ga_event('Full Record', 'View', metadata['id']);

    $('a.json-link').click(function() {
      console.log($(this).attr('href'));
      ga_event('Full Record', 'JSON Click', metadata['id']);
    });

    // Custom Dimension Recording:
    ga('set', 'pageview', {
      'dimension1': metadata['contributing_organization_ssi']
    });

    ga('set', 'pageview', {
      'dimension2': metadata['type_ssi']
    });

    ga('set', 'pageview', {
      'dimension3': metadata['collection_name_ssi']
    });

    $('.navbar-brand').click(function() {
      console.log('Logo');
      ga_event('Logo Click', 'Full Record',  metadata['id']);
    });

    $('.page_links .previous').click(function() {
      console.log('Previous');
      ga_event('Full Record Search Widgets', 'Previous', '');
    });

    $('.page_links .next').click(function() {
      console.log('Next');
      ga_event('Full Record Search Widgets', 'Next', '');
    });

    // 'Back to Search' link
    $('.search-widgets .btn').click(function() {
      console.log('Back to Search');
      ga_event('Full Record Search Widgets', 'Back to Search', '');
    });

    $('.search-widgets #startOverLink').click(function() {
      console.log('Start Over');
      ga_event('Full Record Search Widgets', 'Start Over', '');
    });

    $('.topics-panel a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Sidebar', 'Topics', $(this).text());
    });

    $('.keywords-panel a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Sidebar', 'Keywords', $(this).text());
    });

    $('.more-like-this a').click(function() {
      console.log($(this).attr('alt'));
      ga_event('Full Record Sidebar', 'Related Items', $(this).attr('alt'));
    });

    $('.citation-navigation:first-child').click(function() {
      console.log('Details');
      ga_event('Full Record Metadata Nav', 'Details', metadata['id']);
    });

    $('.citation-navigation li:nth-child(2)').click(function() {
      console.log('Citation');
      ga_event('Full Record Metadata Nav', 'Citation', metadata['id']);
    });

    $('.citation-navigation li:nth-child(3)').click(function() {
      console.log('Download');
      ga_event('Full Record Metadata Nav', 'Download', metadata['id']);
    });

    $('.detail-field-creator a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Creator', $(this).text());
    });

    $('.detail-field-contributingorganization a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Contributing Organization', $(this).text());
    });

    $('.detail-field-type a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Type', $(this).text());
    });

    $('.detail-field-format a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Format', $(this).text());
    });

    $('.detail-field-publishingagency a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Publishing Agency', $(this).text());
    });

    $('.detail-field-dimensions a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Dimensions', $(this).text());
    });

    $('.detail-field-country a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Country', $(this).text());
    });

    $('.detail-field-state a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'State', $(this).text());
    });

    $('.detail-field-county a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'County', $(this).text());
    });

    $('.detail-field-geonamesurl a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'GeoNames URL', $(this).text());
    });

    $('.detail-field-city a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'City', $(this).text());
    });

    $('.detail-field-collectionname a').click(function() {
      console.log($(this).text());
      ga_event('Full Record Details', 'Collection Name', $(this).text());
    });
  });

  // Facets
  $('#facets').each(function() {
    $('.blacklight-physical_format_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Format', $(this).text());
    });

    $('.blacklight-type_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Type', $(this).text());
    });

    $('.blacklight-dat_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Date Created', $(this).text());
    });

    $('.blacklight-county_ssim a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'County', $(this).text());
    });

    $('.blacklight-topic_ssim a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Topic', $(this).text());
    });

    $('.blacklight-keyword_ssim a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Keyword', $(this).text());
    });

    $('.blacklight-collection_name_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Collection', $(this).text());
    });

    $('.blacklight-placename_ssim a').click(function() {
      console.log($(this).text());
      ga_event('Facet Click', 'Location/Placename', $(this).text());
    });
  });

  // Search Results
  $('.blacklight-catalog-index').each(function() {
    $('#search_field').click(function() {
      ga_event('Search Box', 'Search Results', 'Fields Dropdown');
    });

    $('.submit-search-text').click(function() {
      console.log('Seach Click');
      ga_event('Search Box', 'Search Results', 'Search Button');
    });

    $('.search-widgets #sort-dropdown a').click(function() {
      console.log($(this).text());
      ga_event('Search Results Search Widget', 'Sort', $(this).text());
    });

    $('#per_page-dropdown a').click(function() {
      console.log($(this).text());
      ga_event('Search Results Search Widget', 'Per Page', $(this).text());
    });

    $('.view-type-group a.view-type-list').click(function() {
      console.log('view list');
      ga_event('Search Results Search Widget', 'View List', '');
    });

    $('.view-type-group a.view-type-gallery').click(function() {
      console.log('view gallery');
      ga_event('Search Results Search Widget', 'View Gallery', '');
    });

    $('.blacklight-catalog-index .page_links a').click(function() {
      console.log($(this).text());
      ga_event('Search Results Search Widget', 'Pagination', $(this).text());

    $('a.json-link').click(function() {
      console.log($(this).attr('href'));
      ga_event('Search Results', 'JSON Click', $(this).attr('href'));
    });
  });

    // List Results
    $('.blacklight-catalog-index .documents-list').each(function() {
      $('.index_title a').click(function() {
        console.log('Title Click');
        ga_event('Search Results', 'List View', 'Title Click');
      });
      $('.document-thumbnail a').click(function() {
        console.log('Thumbnail Click');
        ga_event('Search Results', 'List View', 'Thumbnail Click');
      });
    });
    // Gallery Results
    $('.blacklight-catalog-index .documents-gallery').each(function() {
      $('.title a').click(function() {
        console.log('Title Click');
        ga_event('Search Results', 'Gallery View', 'Title Click');
      });
      $('.image-wrapper a').click(function() {
        console.log('Thumbnail Click');
        ga_event('Search Results', 'Gallery View', 'Thumbnail Click');
      });
    });
  });

  // Home
  $('.home-page').each(function() {
    $('button.search-btn').click(function() {
      console.log('Home Page Search');
      ga_event('Home Page', 'Search Box', 'Search');
    });

    $('.blacklight-collection_name_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Home Page', 'Collection Name', $(this).text());
    });

    $('.blacklight-physical_format_ssi a').click(function() {
      console.log($(this).text());
      ga_event('Home Page', 'Format', $(this).text());
    });

    $('.blacklight-topic_ssim a').click(function() {
      console.log($(this).text());
      ga_event('Home Page', 'Topic', $(this).text());
    });
  });

  // Footer
  $('.footer-links a').click(function() {
    console.log($(this).text());
    ga_event('Footer', 'Quicklinks', $(this).text());
  });

  $('.footer .logos a').click(function() {
    console.log($(this).attr('href'));
    ga_event('Footer', 'Logos', $(this).attr('href'));
  });

  $('.footer-social a').click(function() {
    console.log($(this).attr('href'));
    ga_event('Footer', 'Social', $(this).attr('href'));
  });

  $('.footer-contact a').click(function() {
    console.log($(this).attr('href'));
    ga_event('Footer', 'Contact Us', $(this).attr('href'));
  });

});
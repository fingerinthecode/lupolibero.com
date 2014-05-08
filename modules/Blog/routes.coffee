angular.module('blog').
config( ($stateProvider) ->
  $stateProvider
    .state('blog', {
      url:         '/blog?page'
      templateUrl: './partials/Blog/list.html'
      controller:  'BlogpostListCtrl'
      resolve: {
        post_max: (Blogpost) ->
          return Blogpost.view({
            view: 'max'
          })
        blogpostList: (Blogpost, $stateParams) ->
          page =  $stateParams.page ? 1
          page--
          return Blogpost.all({
            descending: true
            startkey:   [window.navigator.language, {}]
            endkey:     [window.navigator.language, ""]
            limit:      10
            skip:       page*10
          })
        blogpostListDefault: (Blogpost, $stateParams, $state) ->
          page =  $stateParams.page ? 1
          page--
          return Blogpost.all({
            descending: true
            startkey:   ["en", {}]
            endkey:     ["en", ""]
            limit:      10
            skip:       page*10
          })
      }
    })
    .state('blogpost', {
      url:         '/blog/:blogpostId'
      templateUrl: './partials/Blog/show.html'
      controller:  'BlogpostCtrl'
      resolve: {
        blogpost: (Blogpost, $stateParams) ->
          return Blogpost.get({
            key: $stateParams.blogpostId
          })
      }
    })
)

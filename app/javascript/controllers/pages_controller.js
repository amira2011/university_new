import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pages"
export default class extends Controller {

  
  

  connect() {

    var repos;
    var userName;
   

    $("#search-repos").click(function(e) {
      e.preventDefault();
       console.log("Pages Controller JQuery")
      $(".repos-fetch-spinner").show();
      userName = $("#username").val();
      var uri = `https://api.github.com/users/${userName}/repos`;
      $.get(uri, function(data) {
          repos = data;
          $(".repos-fetch-spinner").hide();
          $.each(repos, function(idx, repo) {
              var html = `<div class='repo-name'>\
                  <img src='${repo.owner.avatar_url}' class='avatar-url'></img>\
                  <a href='javascript:;' class='repo-name' data-repo-id='${repo.id}'>${repo.full_name}</a></div>`;
              $(".repo-list").append(html);
          })
      })
  });


  // display info about the selected repo
  $(document).on('click', '.repo-name', function(e) {
    e.preventDefault();
    var id = $(this).data('repo-id');
    var repo = repos.find(x => x.id == id);
    $(".mpr-list").empty();
    $(".languages-body").empty();
    $("#mpr-spinner").show();
    if (repo) {
        $("#repo-name").text(repo.name);
        $("#repo-desc").text(repo.description);
        $(".stars-count").text(repo.stargazers_count);
        $(".watchers-count").text(repo.watchers_count);
        $(".forks-count").text(repo.forks_count);
        var prClosedUri = `https://api.github.com/repos/${userName}/${repo.name}/pulls?state=closed`;
        var prOpenUri = `https://api.github.com/repos/${userName}/${repo.name}/pulls?state=open`;
        var issuesOpenUri = `https://api.github.com/repos/${userName}/${repo.name}/issues?state=open`;
        var issuesClosedUri = `https://api.github.com/repos/${userName}/${repo.name}/issues?state=closed`;
        var languagesUri = `https://api.github.com/repos/${userName}/${repo.name}/languages`;
        $.get(prClosedUri, function(data) {
            $(".mpr").text(data.length);
            $("#mpr-spinner").hide();
            if (data.length > 0) {
                $.each(data, function(idx, rec) {
                    var html = `<div class='row'>
                        <div class='col-auto'><i class='fa fa-code-merge'></i></div>\
                        <div class='col-md-11' style='padding-left: 0;'>
                            <div class='mpr-title'>${rec.title}</div>
                            <div class='mpr-subtitle'>#${rec.number} merged few hours ago</div>
                        </div></div>`;
                    $(".mpr-list").append(html);
                });
            }
        });
        $.get(prOpenUri, function(data) {
            $(".opr").text(data.length);
        });
        $.get(issuesOpenUri, function(data) {
            $(".ois").text(data.length);
        });
        $.get(issuesClosedUri, function(data) {
            $(".cis").text(data.length);
        });
        $.get(languagesUri, function(data) {
            $.each(data, function(k, v) {
                var html = `<div>${k}</div>`;
                $(".languages-body").append(html);
            })
        });
        $(".repo-info").show();
    }
});


$(document).on('click', '.repo-name1', function(e) {
  e.preventDefault();
  var id = $(this).data('repo-id');
  $(".repo-info").show();
   
  console.log(id)
});


  }
}

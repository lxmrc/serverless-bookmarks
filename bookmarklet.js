javascript: (() => {
  const Http = new XMLHttpRequest();
  const pageUrl = window.location.href;
  const pageTitle = document.title;
  const url='https://serverless-bookmarks.vercel.app/api/bookmark?url=' + pageUrl + '&title=' + pageTitle;

  Http.open("GET", url);
  Http.send();
})();

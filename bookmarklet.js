// bookmark
javascript: (() => {
  const Http = new XMLHttpRequest();
  const pageUrl = window.location.href;
  const pageTitle = document.title;
  const url='https://serverless-bookmarks.vercel.app/api/bookmark?url=' + pageUrl + '&title=' + pageTitle + '&list=bookmarks';

  Http.open("GET", url);
  Http.send();
})();


// read later
javascript: (() => {
  const Http = new XMLHttpRequest();
  const pageUrl = window.location.href;
  const pageTitle = document.title;
  const url='https://serverless-bookmarks.vercel.app/api/bookmark?url=' + pageUrl + '&title=' + pageTitle + '&list=read_later';

  Http.open("GET", url);
  Http.send();
})();

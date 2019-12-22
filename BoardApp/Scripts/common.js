$('#returToIndex').click((e) => {
    sessionStorage.removeItem('pageScale');
    sessionStorage.removeItem('curPage');
    sessionStorage.removeItem('pageSize-text');
    location.href = "/Board/Index";
});
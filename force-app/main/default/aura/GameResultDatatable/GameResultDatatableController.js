({
  doInit: function (cmp, event, helper) {
    cmp.set('v.columns', [
      { label: 'Game Number', fieldName: 'Name', type: 'text' },
      { label: 'Game Mode', fieldName: 'Game_Mode__c', type: 'text' },
      { label: 'Result', fieldName: 'Result__c', type: 'text' },
      { label: 'Played On', fieldName: 'CreatedDate', type: 'date' },
    ]);
    helper.fetchData(cmp);
  },
  onResultHandler: function (cmp, event, helper) {
    helper.fetchData(cmp);
  }
})

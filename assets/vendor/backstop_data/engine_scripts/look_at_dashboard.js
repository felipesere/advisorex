module.exports = function(casper, scenario, vp) {
  casper.click('.login');
  casper.wait( 250 );
  casper.click('a[href="/dashboard"]');
}

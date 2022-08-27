function checkout(optionsStr) {
  var options = JSON.parse(optionsStr);  options.handler = function (response) {
      window.sessionStorage.setItem('razorpayStatus',
        'SUCCESS');
      window.sessionStorage.setItem('razorpayOrderId', 
        response.razorpay_order_id);
      window.sessionStorage.setItem('paymentId',
        response.razorpay_payment_id);
      window.sessionStorage.setItem('signature',  
        response.razorpay_signature);
  }
  var rzp1 = new Razorpay(options); rzp1.on('payment.failed', function (response) {
        window.sessionStorage.setItem('razorpayStatus', 'FAILED');
    });  rzp1.open();
}
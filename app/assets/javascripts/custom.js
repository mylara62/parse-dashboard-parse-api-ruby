$(function(){
	$('#user_table, #coin_data, #trigger_table, #hash_tag_table, #history_table, #coin_rank_table, #sender_rank_table, #receiver_ranking_table').DataTable({
	  "aoColumnDefs" : [
	       {
	         'bSortable' : false,
	         'aTargets' : [ 'action']
	       }]
	});
	$('body').on('change',"#rewardCoinTypeID",function(){
		$.ajax({
			method: "get",
			url: '/challanges/get_coin_type',
			data: {coinTypeId: this.value}
		});
	});
	$('body').on('change',"#coinTypeID",function(){
	  $.ajax({
			method: "get",
			url: '/challanges/get_coin_type',
			data: {coinTypeId: this.value,type: "Coin"}
		});
	});
	$('body').on('change',"#coin_coinTypeObjectID",function(){
		$.ajax({
			method: "get",
			url: '/challanges/get_coin_type',
			data: {coinTypeId: this.value,type: "coinTypeObject"}
		});
	});

	$('body').on('click','.create-trigger-btn',function(){
		window.location = window.location.pathname = "/challanges/new"
	});
	$('body').on('click','.create-coin-btn',function(){
		window.location = window.location.pathname = "/coins/new"
	});
});
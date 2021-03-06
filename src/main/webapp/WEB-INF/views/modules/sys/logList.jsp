<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function () {
			var actions = {
				list: {method: 'get', url: '${ctxRest}/sys/log'}
			};

			var resource;
			new Vue({
				el : "body",
				data : {
					param: {pageNo: 0, pageSize: 10},
					page : {}
				},
				ready: function () {
					resource = this.$resource(null, {}, actions);

					// 设置页码
					this.param.pageNo = 1;
				},
				methods: {
					query : function () {
						resource.list(this.param).then(function (response) {
							this.page = response.json();
						});
					}
				},
				watch: {
					'param': {
						handler: function () {
							// 监听查询条件对象，如果有更改就查询数据
							this.query();
						},
						deep: true
					}
				}
			});

			bindDataTimePicker();
		});

		/**
		 * 绑定事件选择控件
		 */
		function bindDataTimePicker() {
			$('.form-date').datetimepicker({
				language: 'zh-CN',
				todayBtn: 1,
				autoclose: 1,
				todayHighlight: 1,
				forceParse: 0,
				viewMode: 'days',
				format: 'yyyy-mm-dd',
				startView : 'month',
				minView : 'month',
				maxView : 'year'
			});
		}
	</script>
</head>
<body>
<section class="content-header">
	<h1>日志列表
	</h1>
	<ol class="breadcrumb">
		<li><a href="${ctx}/sys/log"><i class="fa fa-dashboard"></i>系统设置</a></li>
		<li class="active">日志列表</li>
	</ol>
</section>
<section class="content">
	<div class="row">
		<div class="col-xs-12">
			<div class="box">
				<div class="box-header">
					<form class="form-inline" @keyup.enter="query()">
						<div class="form-group">
							<label class="control-label">URI</label>
							<input class="form-control inline-block" type="text" v-model="param.requestUri">
						</div>
						<div class="form-group">
							<label class="control-label">操作用户</label>
							<input class="form-control inline-block" type="text" v-model="param.createByName" placeholder="姓名/登录名">
						</div>
						<div class="form-group">
							<label class="control-label">时间</label>
							<div class='input-group date'>
								<input type='text' class="form-control form-date" readonly  v-model="param.beginDate" value='<fmt:formatDate value="${beginDate}" pattern="yyyy-MM-dd"/>'/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
							-
							<div class='input-group date'>
								<input type='text' class="form-control form-date" readonly v-model="param.endDate" value='<fmt:formatDate value="${endDate}" pattern="yyyy-MM-dd"/>'/>
								<span class="input-group-addon">
									<span class="glyphicon glyphicon-calendar"></span>
								</span>
							</div>
						</div>
						<div class="form-group">
							<a class="btn btn-primary" @click="query()">查询</a>
						</div>
					</form>
				</div>
				<div class="box-body">
					<table class="table table-bordered table-hover">
						<thead>
						<tr>
							<th>所在公司</th>
							<th>所在部门</th>
							<th>操作用户</th>
							<th>URI</th>
							<th>提交方式</th>
							<th>操作者IP</th>
							<th>创建时间</th>
						</tr>
						</thead>
						<tbody>
						<tr v-for="obj of page.list">
							<td><span v-text="obj.createBy.company.name"></span></td>
							<td><span v-text="obj.createBy.office.name"></span></td>
							<td><span v-text="obj.createBy.name"></span>（<span v-text="obj.createBy.loginName"></span>）</td>
							<td><span v-text="obj.requestUri"></span></td>
							<td><span v-text="obj.method"></span></td>
							<td><span v-text="obj.remoteAddr"></span></td>
							<td><span v-text="obj.createDate"></span></td>
						</tr>
						</tbody>
					</table>

					<pagination :page="page"  :page-no.sync="param.pageNo" :page-size.sync="param.pageSize"></pagination>
				</div>
			</div>
		</div>
	</div>
</section>
</body>
</html>
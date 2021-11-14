<!DOCTYPE html>
<html lang="ja">
	<head>
		<meta charset="utf-8">
		<title>CRUD</title>
		<meta name="description" content="General Purpose CRUD Engine">
		<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
		<style>

			body {
				line-height: 1.5em;
				font-family: -apple-system, BlinkMacSystemFont, Roboto, "Segoe UI", "Helvetica Neue", HelveticaNeue, YuGothic, "Yu Gothic Medium", "Yu Gothic", Verdana, Meiryo, sans-serif;
				font-size: 14px;
				padding: 0;
				margin: 0;
				color: #666;
			}

			.clickable:hover {
				opacity: 0.8;
			}
			.clickable:active {
				opacity: 0.6;
			}

			#header,
			#content,
			#form {
				float: left;
			}

			#container,
			#header,
			#content,
			#form,
			#footer {
				width: 100%;
				overflow: hidden;
				box-sizing: border-box;
			}

			#header {
				background-color: #1e90ff;
				padding: 20px 0 8px 10px;
			}

			#app-title {
				display: inline-block;
				float: left;
				margin: 0 0 10px 0;
			}

			#app-title a {
				font-size: 44px;
				color: #fff;
				text-decoration: none;
			}

			#app-sub-title {
				float: left;
				clear: left;
				margin: 0;
				font-size: 10px;
				font-weight: normal;
				color: #fff;
			}

			#content {
				padding-bottom: 60px;
			}

			#form {
				float: left;
				width: 100%;
				overflow: hidden;
				box-sizing: border-box;
				padding: 20px;
			}

			.field,
			.buttons {
				float: left;
				overflow: hidden;
				box-sizing: border-box;
				padding: 10px 0;
			}

			.field {
				width: auto;
				height: 45px;
				padding-right: 40px;
			}

			.field label {
				float: left;
				margin: 0 10px 0 0;
			}

			.field span {
				float: left;
				margin: 0 10px;
			}

			.field input[type="number"] {
				float: left;
				width: 60px;
			}

			.field input[type="date"] {
				float: left;
				width: 130px;
			}

			.field input[type="text"],
			.field input[type="email"] {
				float: left;
				width: 180px;
			}

			.buttons {
				width: auto;
			}

			.buttons input[type="submit"],
			.buttons input[type="button"] {
				float: left;
				width: 80px;
				margin: 0 10px;
			}

			#data-header {
				float: left;
				width: 100%;
				overflow: hidden;
				box-sizing: border-box;
				padding: 5px 10px 25px 10px;
			}

			#data {
				float: left;
				width: 100%;
				overflow: hidden;
				box-sizing: border-box;
				padding: 20px;
			}

			#no-data {
				float: left;
				width: 100%;
				overflow: hidden;
				box-sizing: border-box;
				padding: 20px;
				margin: 0;
				border-top: 1px solid #999;
			}

			table {
				width: 100%;
				border-collapse: collapse;
  			border-spacing: 0;
			}

			th {
				border-bottom: 2px solid #999;
				padding: 0 10px 10px 10px;
				color: #1e90ff;
				text-align: left;
			}

			td {
				max-width: 300px;
				border-bottom: 1px solid #999;
				padding: 20px 10px;
				text-align: left;
			}

			.col-detail {
				vertical-align: top;
			}

			.col-no {
				vertical-align: top;
			}

			.col-list p {
				display: -webkit-box;
				height: 80px;
				overflow: hidden;
				-webkit-box-orient: vertical;
				-webkit-line-clamp: 3;
				margin: 0;
				vertical-align: baseline;
			}

			.col-value p {
				float: left;
				max-width: 800px;
				overflow: hidden;
				margin: 0;
			}

			.col-label {
				width: 200px;
				font-weight: bold;
				color: #1e90ff;
			}

			#footer {
				position: fixed;
				bottom: 0;
				left: 0;
				padding: 10px;
				background-color: #1e90ff;
			}

			#copyright {
				float: right;
				display: inline-block;
				margin: 0;
				color: #fff;
				text-align: center;
			}

			#to-top {
				display: none;
				margin-right: 10px;
			}

			#to-top,
			#paging,
			#pageing ul {
				float: left;
				width: auto;
				overflow: hidden;
				box-sizing: border-box;
			}

			#paging ul {
				list-style: none;
				padding: 0;
				margin: 0;
			}

			#paging li {
				float: left;
				width: auto;
				overflow: hidden;
				box-sizing: border-box;
				text-align: center;
				margin-right: 10px;
			}

			#page-top-btn,
			#paging li a {
				display: block;
				width: 40px;
				height: 25px;
				line-height: 25px;
				border-radius: 3px;
				background-color: #fff;
				font-size: 12px;
				color: #1e90ff;
				text-decoration: none;
				text-align: center;
			}

			#page-top-btn {
				width: 120px;
			}

		</style>
		<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
		<script>

			//---- 設定値 ----//

			const filePath = 'data.csv'; // ファイルパス
			const appTitle = '@DSApp'; // アプリケーションタイトル
			const appSubTitle = 'Auto Turn Data Source into an Application'; // アプリケーションサブタイトル
			const copyright = 'Copyright © 2021 XXXXXXXX All Rights Reserved.'; // コピーライト
			const perPageRows = 3; // ページング毎の表示行数

			//---- 設定値を反映 ----//

				$(function(){
					$( '#app-title a' ).text( appTitle );
					$( '#app-sub-title' ).text( appSubTitle );
					$( '#copyright' ).text( copyright );
				});

			/**** CSVファイルを読み込む 関数 getCSV() の定義 ****/

				function getCSV()
				{
				  var req = new XMLHttpRequest(); // HTTP でファイルを読み込むための XMLHttpRrequest オブジェクトを生成
				  req.open( "get", filePath, true ); // アクセスするファイルを指定
				  req.send( null ); // HTTPリクエストの発行

				  req.onload = function() // レスポンスが返ってきたら convertCSVtoArray() を呼ぶ	
				  {
						convertCSVtoArray( req.responseText ); // 渡されるのは読み込んだCSVデータ
				  }
				}
			 
			/**** 読み込んだCSVデータを二次元配列に変換する ( 関数 convertCSVtoArray() の定義 ) ****/

				function convertCSVtoArray( str ) // 読み込んだCSVデータが文字列として渡される
				{
					//---- 変数の初期化 ----//

						var columns = []; // 最終的に二次元配列を入れるための配列
						var display_rows = []; // 表示する行かどうかの判定値 ( 0 = 非表示, 1 = 表示 )

						// ↓ カラム設定値 ( １〜６行目まで ) を取得 //
					  var column_names = []; // １行目 : 物理カラム名
					  var column_labels = []; // ２行目 : 表示カラム名
					  var display_columns = []; // ３行目 : カラム毎の 表示 or 非表示 フラグ ( 0 = 非表示, 1 = 表示 )
					  var keyword_search_columns = []; // ４行目 : カラム毎の キーワード検索 対象外 or 対象 フラグ ( 0 = 対象外, 1 = 対象 )
					  var search_field_type = []; // ５行目 : カラム毎の 検索フィールドタイプ
					  var search_field_options = []; // ６行目 : カラム毎の 選択項目値

					  var field_options = []; // 選択項目の選択値 ( '/' で区切られた文字列 )
						var default_selected = ''; // 未選択時の選択値に 'selected' を格納
					  var option_selected = ''; // 選択項目のアクティブ選択値に 'selected' を格納
						var col_value = ''; // 正規表現チェック後のカラム値

					//---- 値の取得 ----//

						str = str.replace(/\r?\n/g, "\n"); // あらゆる改行コードをすべて ( \n ) に統一

						// 行毎のデータを取得 //
						var rows = str.split( "\n" ); // 改行コード ( \n ) を区切り文字として行を要素とした配列を生成

						// 列毎のデータを取得 //
					  for( var i = 0; i < rows.length; i ++ ) // 行データ毎の処理
					  {
					  	// 行 × 列 の２次元配列 //
					    columns[ i ] = rows[ i ].split( ',' ); // カンマを区切れ文字とした配列を生成
					  }

					//---- CSV内１行目〜６行目の設定値を取得 ----//

						for( var i = 0; i < rows.length; i ++ ) // 行毎の処理
						{
							if( i == 0 ) // １行目 ( 物理カラム名 ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// 物理カラム名 //
									column_names[ j ] = columns[ i ][ j ];
								}
							}
							else if( i == 1 ) // ２行目 ( 表示カラム名 ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// 表示カラム名 //
									column_labels[ j ] = columns[ i ][ j ];
								}
							}
							else if( i == 2 ) // ３行目 ( 表示 or 非表示 フラグ ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// 表示 or 非表示 フラグ //
									display_columns[ j ] = columns[ i ][ j ]; // 入力値 = ( 0 = 非表示, 1 = 表示 )
								}
							}
							else if( i == 3 ) // ４行目 ( キーワード検索 対象外 or 対象 フラグ ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// キーワード検索 対象外 or 対象 フラグ //
									keyword_search_columns[ j ] = columns[ i ][ j ]; // 入力値 = ( 0 = 対象外, 1 = 対象 )
								}
							}
							else if( i == 4 ) // ５行目 ( 検索フィールドタイプ ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// 検索フィールドタイプ //
									search_field_type[ j ] = columns[ i ][ j ];
									// 0 = なし, 1 = 数値範囲, 2 = 日付範囲, 3 = テキスト, 4 = プルダウン
								}
							}
							else if( i == 5 ) // ６行目 ( 選択項目値 ) の場合
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									// 選択項目値 //
									search_field_options[ j ] = columns[ i ][ j ]; // "/" 区切れの文字列
								}
							}
						}

					//---- 検索フィールド毎に入力されたGETパラメータ値を取得 ----//

						var params = ( new URL( document.location ) ).searchParams; // GETパラメータ全体を取得

						// レコードの ID を取得 //
						var get_rid = params.get( 'rid' );

						// 行 ID を取得 ( アンカーリンク用 ) //
						var get_row = params.get( 'row' );

						if( get_rid != null && get_rid != '' ) // レコード ID の指定があった場合
						{
							for( var j = 0; j < columns[ 0 ].length; j ++ )
							{
								if( search_field_type[ j ] == '1' || search_field_type[ j ] == '2' ) // 数値 、日付 などの範囲指定フィールドの場合
								{
									// 範囲 ( 開始値 ～ 終了値 ) を取得
									eval( 'var get_' + column_names[ j ] + '_start = "";' );
									eval( 'var get_' + column_names[ j ] + '_end = "";' );
								}
								else // 文字列系の単一フィールド以外の場合
								{
									// 入力値を取得
									eval( 'var get_' + column_names[ j ] + ' = "";' );

									// "null" 文字をブランクにする
									if( eval( 'get_' + column_names[ j ] ) == null )
									{
										eval( 'get_' + column_names[ j ] + ' = "";' );
									}
								}
							}

							// 検索キーワードを取得 //
							var get_keyword = params.get( 'keyword' );

							if( get_keyword == null ) //  検索キーワードフィールドが "null" or ブランク の場合
							{
								// "null" 文字をブランクにする
								get_keyword = '';
							}
						}
						else // レコード ID の指定が無かった場合
						{
							for( var j = 0; j < columns[ 0 ].length; j ++ )
							{
								if( search_field_type[ j ] == '1' || search_field_type[ j ] == '2' ) // 数値 、日付 などの範囲指定フィールドの場合
								{
									// 範囲 ( 開始値 ～ 終了値 ) を取得
									eval( 'var get_' + column_names[ j ] + '_start = params.get( "' + column_names[ j ] + '_start" );' );
									eval( 'var get_' + column_names[ j ] + '_end = params.get( "' + column_names[ j ] + '_end" );' );
								}
								else // 文字列系の単一フィールド以外の場合
								{
									// 入力値を取得
									eval( 'var get_' + column_names[ j ] + ' = params.get( "' + column_names[ j ] + '" );' );

									// "null" 文字をブランクにする
									if( eval( 'get_' + column_names[ j ] ) == null )
									{
										eval( 'get_' + column_names[ j ] + ' = "";' );
									}
								}
							}

							// 検索キーワードを取得 //
							var get_keyword = params.get( 'keyword' );

							if( get_keyword == null ) //  検索キーワードフィールドが "null" or ブランク の場合
							{
								// "null" 文字をブランクにする
								get_keyword = '';
							}
						}

					if( get_rid == null || get_rid == '' ) // レコード ID の指定が無かった場合
					{
						//---- 上記 CSV内１行目〜６行目の設定値 をもとに検索フィールドを生成 ----//

							// form 変数を初期化 //
							var form = '';

								for( var j = 0; j < columns[ 4 ].length; j ++ ) // 列毎の処理
								{
									// 検索フィールドタイプ判定 //
									switch( search_field_type[ j ] )　// 0 = なし, 1 = 数値範囲, 2 = 日付範囲, 3 = テキスト, 4 = メールアドレス, 5 = プルダウン
									{
										case '1': // 数値範囲 フィールドを出力 //

											form += "<div class=\"field number\">\n";
											form += "<label>" + columns[ 1 ][ j ] + "</label>\n";
											form += "<input name=\"" + columns[ 0 ][ j ] + "_start\" type=\"number\" value=\"" + eval( 'get_' + column_names[ j ] + '_start' ) + "\">\n";
											form += "<span> ～ </span>";
											form += "<input name=\"" + columns[ 0 ][ j ] + "_end\" type=\"number\" value=\"" + eval( 'get_' + column_names[ j ] + '_end' ) + "\">\n";
											form += "</div>\n";

										break;

										case '2': // 日付範囲 フィールドを出力 //

											form += "<div class=\"field date\">\n";
											form += "<label>" + columns[ 1 ][ j ] + "</label>\n";
											form += "<input name=\"" + columns[ 0 ][ j ] + "_start\" type=\"date\" value=\"" + eval( 'get_' + column_names[ j ] + '_start' ) + "\">\n";
											form += "<span> ～ </span>";
											form += "<input name=\"" + columns[ 0 ][ j ] + "_end\" type=\"date\" value=\"" + eval( 'get_' + column_names[ j ] + '_end' ) + "\">\n";
											form += "</div>\n";

										break;

										case '3': // テキスト フィールドを出力 //

											form += "<div class=\"field text\">\n";
											form += "<label>" + columns[ 1 ][ j ] + "</label>\n";
											form += "<input name=\"" + columns[ 0 ][ j ] + "\" type=\"text\" value=\"" + eval( 'get_' + column_names[ j ] ) + "\">\n";
											form += "</div>\n";

										break;

										case '4': // プルダウン フィールドを出力 //

											form += "<div class=\"field select\">\n";
											form += "<label>" + columns[ 1 ][ j ] + "</label>\n";
											form += "<select name=\"" + columns[ 0 ][ j ] + "\">\n";
											
											// 未選択時の選択項目 //
											form += "<option value=\"\" " + default_selected + ">選択してください</option>\n";

											// '/' 区切れの選択項目文字列を配列化 //
											var field_options = ( search_field_options[ j ].split( '/' ) );

											for( var k = 0; k < field_options.length; k ++ ) // 選択項目毎の処理
											{
												if( field_options[ k ] == eval( 'get_' + column_names[ j ] ) ) //  選択項目が検索フィールド上の入力値と一致した場合
												{
													option_selected = 'selected'; // アクティブ表示
												}
												else
												{
													option_selected = ''; // 非アクティブ表示
												}

												// プルダウン選択項目として出力 //
												form += "<option value=\"" + field_options[ k ] + "\" " + option_selected + ">" + field_options[ k ] + "</option>\n";
											}

											form += "</select>\n";
											form += "</div>\n";

										break;
									}
								}

								// 検索フィールドを出力 //
								form += "<div class=\"field\">\n";
								form += "<label>検索キーワード</label>\n";
								form += "<input name=\"keyword\" type=\"text\" value=\"" + get_keyword + "\">\n";
								form += "</div>\n";

								// 検索ボタンを出力 //
								form += "<div class=\"buttons\">\n";
								form += "<input type=\"button\" value=\"クリア\" onClick=\"location.href=\'./index.aspx\'\">\n";
								form += "<input type=\"submit\" value=\"検索\">\n";
								form += "</div>\n";

							//---- 上記で生成された検索フィールドを "#form" 内へ出力 //

								$(function(){
									$( '#form' ).html( form );
								});
					}

					//---- ( レコード ID の指定があった場合 or 無かった場合 ) のデータ照合 ----//

						let cols_check = 0; // 任意表示 検索フィールドでヒットしたカラムのカウント
						let cols_result = false; // 任意表示 検索フィールドすべての入力判定結果
						let keys_check = 0; // キーワードでヒットしたカラムのカウント
						let keys_result = false; // キーワードでヒットしたカラムの入力判定結果
						let dis_row_count = 0; // 表示行数カウント

						if( get_rid != null && get_rid != '' ) // レコード ID の指定があった場合
						{
							for( var i = 0; i < rows.length; i ++ ) // 行毎の処理
							{
								for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
								{
									if( columns[ i ][ 0 ] == get_rid )
									{
										display_rows.push( i );
									}
								}
							}
						}
						else // レコード ID の指定が無かった場合
						{
							//---- フォーム入力された検索条件をデータ照合 ----//

								for( var i = 0; i < rows.length; i ++ ) // 行毎の処理
								{
									if( i > 5 ) // CSV内１行目〜６行目の設定値 以降の行の処理
									{
										for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
										{
											//---- 任意表示 検索フィールド の場合の判定 ----//

												if( search_field_type[ j ] == '1' || search_field_type[ j ] == '2' ) // 数値 、日付 などの範囲指定フィールドの場合
												{
													if(
														( eval( 'get_' + column_names[ j ] + '_start' ) != null && eval( 'get_' + column_names[ j ] + '_start' ) != '' ) && 
														( eval( 'get_' + column_names[ j ] + '_end' ) != null && eval( 'get_' + column_names[ j ] + '_end' ) != '' )
													) // 開始値、終了値 の両方が入力されている場合
													{
														if( 
															columns[ i ][ j ] >= eval( 'get_' + column_names[ j ] + '_start' ) && 
															columns[ i ][ j ] <= eval( 'get_' + column_names[ j ] + '_end' )
														)
														{
															cols_check ++;
														}
													}
													else if(
														( eval( 'get_' + column_names[ j ] + '_start' ) != null && eval( 'get_' + column_names[ j ] + '_start' ) != '' ) && 
														( eval( 'get_' + column_names[ j ] + '_end' ) == null || eval( 'get_' + column_names[ j ] + '_end' ) == '' )
													) // 開始値 のみが入力されている場合
													{
														if( 
															columns[ i ][ j ] >= eval( 'get_' + column_names[ j ] + '_start' )
														)
														{
															cols_check ++;
														}
													}
													else if(
														( eval( 'get_' + column_names[ j ] + '_start' ) == null || eval( 'get_' + column_names[ j ] + '_start' ) == '' ) && 
														( eval( 'get_' + column_names[ j ] + '_end' ) != null && eval( 'get_' + column_names[ j ] + '_end' ) != '' )
													) // 終了値 のみが入力されている場合
													{
														if( 
															columns[ i ][ j ] <= eval( 'get_' + column_names[ j ] + '_end' )
														)
														{
															cols_check ++;
														}
													}
													else // 上記以外 ( 開始値、終了値 両方とも入力なし ) の場合
													{
														cols_check ++;
													}
												}
												else if( 
													search_field_type[ j ] == '3' || 
													search_field_type[ j ] == '4' || 
													search_field_type[ j ] == '5' ) // テキスト 、メールアドレス プルダウン　フィールドの場合
												{
													if( eval( 'get_' + column_names[ j ] ) != null && eval( 'get_' + column_names[ j ] ) != '' ) // フィールド入力がある場合
													{
														if( columns[ i ][ j ].indexOf( eval( 'get_' + column_names[ j ] ) ) != -1 ) //  カラム内の値 に フィールド入力値 が含まれている場合
														{
															cols_check ++;
														}
													}
													else // フィールド入力が無い場合
													{
														cols_check ++;
													}
												}
												else
												{
													cols_check ++;
												}
											
											//---- 検索キーワードフィールド の場合の判定 ----//

												if( keyword_search_columns[ j ] == '1' ) // ４行目 ( キーワード検索 対象外 or 対象 フラグ ) の値が '1' ( true ) の場合
												{
													if( get_keyword != null && get_keyword != '' ) //  検索キーワードが入力されている場合
													{
														if( columns[ i ][ j ].indexOf( get_keyword ) != -1 ) //  カラム内の値 に 検索キーワード が含まれている場合
														{
															keys_check ++;
														}
													}
													else //  検索キーワードが入力されていない場合
													{
														keys_check ++;
													}
												}
										}

										// 任意表示 検索フィールドすべての入力判定結果 //
										if( cols_check == columns[ i ].length )
										{
											cols_result = true;
										}
										else
										{
											cols_result = false;
										}

										// キーワードでヒットしたカラムの入力判定結果 //
										if( keys_check > 0 )
										{
											keys_result = true;
										}
										else
										{
											keys_result = false;
										}

										//---- 該当行データとして出力するかどうかの判定 ----//

											if(	cols_result == true && keys_result == true ) // 検索ヒットしたカラムが存在した場合
											{
												display_rows.push( i ); // display_rows 配列変数に行番号 ( i ) を代入
												dis_row_count ++; // 表示行としてカウント
											}

											cols_check = 0; // 任意表示 検索フィールドでヒットしたカラムのカウントを初期化
											cols_result = false; // 任意表示 検索フィールドすべての入力判定結果を初期化
											key_cols_count = 0; // キーワード検索 対象カラムのカウントを初期化
											keys_check = 0; // キーワードでヒットしたカラムのカウントを初期化
											keys_result = false; // キーワードでヒットしたカラムの入力判定結果を初期化
									}
								}
						}

					//---- テーブルを出力 ----//

						// data 変数を初期化 //
						var data = '';

						if( get_rid != null && get_rid != '' ) // レコード ID の指定があった場合
						{
							data += "<style> \n #form { display: none; } \n table { border-top: 1px solid #999; } \n </style>\n";
							data += "<div id=\"data-header\"><input type=\"button\" value=\"一覧画面へ戻る\" onClick=\"history.back()\"></div>\n";

							// テーブル ( ここから ～ ) //
							data += "<table>\n";

							//---- 行データ出力 ----//

								for( var i = 6; i < rows.length; i ++ ) // 行毎の処理
								{
									var number = i - 5; // "No." ( 項番 ) の値　( CSV内１行目〜６行目の設定値分を除外 )

									if( display_rows.includes( i ) == true ) // display_rows 配列変数の値が '1' ( true ) の場合
									{
										for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
										{
											if( display_columns[ j ] == '1' )  // ３行目 ( 表示 or 非表示 フラグ ) の値が '1' ( true ) の場合
											{
												var regex_email = new RegExp(/^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}.[A-Za-z0-9]{1,}$/);
												
												if ( regex_email.test( columns[ i ][ j ] ) ) {
													col_value = "<a href=\"mailto:" + columns[ i ][ j ] + "\">" + columns[ i ][ j ] + "</a>\n";
												}
												else
												{
													// 正規表現でURLを検出しリンクタグを付ける //
													col_value = columns[ i ][ j ].replace(/((?<!src=")\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gi, "<a href=\"$&\">$&</a>");
												}

												data += "<tr>\n";
												data += "<td class=\"col-label\">" + columns[ 1 ][ j ] + "</td>\n"; // 行データ中のカラムラベルを出力
												data += "<td class=\"col-value\"><p>" + col_value + "</p></td>\n"; // 行データ中のカラム値を出力
												data += "</tr>\n";
											}
										}
									}
								}

							// テーブル ( ～ ここまで ) //
							data += "</table>\n";
						}
						else // レコード ID の指定が無かった場合
						{
							if( dis_row_count > 0 ) // 表示行があった場合
							{
								// テーブル ( ここから ～ ) //
								data += "<table>\n";

								//---- ヘッダ出力 ----//

									data += "<tr>\n";
									data += "<th class=\"col-detail\">詳細表示</th>\n";
									data += "<th class=\"col-no\">No.</th>\n";

									for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
									{
										if( display_columns[ j ] == '1' )  // ３行目 ( 表示 or 非表示 フラグ ) の値が '1' ( true ) の場合
										{
											data += "<th class=\"col-" + columns[ 0 ][ j ] + "\">" + columns[ 1 ][ j ] + "</th>\n"; // ヘッダーカラムを出力
										}
									}

									data += "</tr>\n";

								//---- 行データ出力 ----//

									for( var i = 0; i < rows.length; i ++ ) // 行毎の処理
									{
										var number = i - 5; // "No." ( 項番 ) の値　( CSV内１行目〜６行目の設定値分を除外 )

										if( display_rows.includes( i ) == true ) // display_rows 配列変数の値が '1' ( true ) の場合
										{
											data += "<tr id=\"row-" + number + "\">\n";
											data += "<td class=\"col-detail\"><input type=\"button\" value=\"詳細表示\" onClick=\"location.href=\'./index.aspx?rid=" + columns[ i ][ 0 ] + "\'\"></td>\n";
											data += "<td class=\"col-no\">" + number + "</td>\n"; // "No." ( 項番 ) カラム

											for( var j = 0; j < columns[ 0 ].length; j ++ ) // 列毎の処理
											{
												if( display_columns[ j ] == '1' )  // ３行目 ( 表示 or 非表示 フラグ ) の値が '1' ( true ) の場合
												{
													var regex_email = new RegExp(/^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}.[A-Za-z0-9]{1,}$/);
												
													if ( regex_email.test( columns[ i ][ j ] ) ) {
														col_value = "<a href=\"mailto:" + columns[ i ][ j ] + "\">" + columns[ i ][ j ] + "</a>\n";
													}
													else
													{
														// 正規表現でURLを検出しリンクタグを付ける //
														col_value = columns[ i ][ j ].replace(/((?<!src=")\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gi, "<a href=\"$&\">$&</a>");
													}

													data += "<td class=\"col-" + columns[ 0 ][ j ] + " col-list\"><p>" + col_value + "</p></td>\n"; // 行データ中のカラムを出力
												}
											}

											data += "</tr>\n";
										}
									}

								// テーブル ( ～ ここまで ) //
								data += "</table>\n";

								paging = '';

								// ページング ( ここから ～ ) //
								paging += "<ul>\n";

								$(function(){
									$(window).scroll(function () {
										var nowScrollTop = $( 'html, body' ).scrollTop(); // 現在のスクロールポジション値を取得
										if( nowScrollTop > 300 ) // スクロールポジション値が 1000px 以上の場合
										{
											$( '#to-top' ).show().html( "<a id=\"page-top-btn\" class=\"clickable\" href=\"./index.aspx#header\">↑ ページトップへ</a>\n" ); //「 ↑ ページトップへ 」ボタンを表示
										}
										else
										{
											$( '#to-top' ).hide();
										}
									});
								});

								if( dis_row_count > perPageRows ) // 検索ヒット数 が 設定された ページング毎の表示行数 より多い場合
								{
									//---- ページング出力 ----//

									let peging_link_num = 0; // ジャンプ先の行番号

									let pagingNum = rows.length / perPageRows; // ページング全体の数

									for( var i = 1; i < pagingNum; i ++ ) // 行毎の処理
									{
										peging_link_num = perPageRows * i - perPageRows + 1; // ページングリンクとして表示する数値

										if( peging_link_num < dis_row_count ) // 表示必要のある数値以上は非表示
										{
											paging += "<li><a id=\"peg-row-" + peging_link_num + "\" class=\"clickable\" href=\"./index.aspx?row=" + peging_link_num + "\" title=\"" + peging_link_num + "\">" + peging_link_num + "</a></li>\n";
										}
									}

									$(function(){
										$( '#paging' ).html( paging ); // ページングを表示
									});
								}

								// ページング ( ～ ここまで ) //
									paging += "</ul>\n";
							}
							else // 表示行が無かった場合
							{
								data += "<p id=\"no-data\">データがありません。</p>\n";

								$(function(){
									$( '#paging' ).hide();
								});
							}
						}

						//---- 上記で生成された検索フィールドを "#data" 内へ出力 //

							$(function(){
								$( '#data' ).html( data );
							});

							$(function(){
								if( get_row != null && get_row != '' ) // パラメータに 行 ID ( get_row ) の値があったら
								{
									$( '#row-' + get_row ).css( 'background-color', '#e0ffff' ); // アクティブ行に色付け
									var activeRowPosition = $( '#row-' + get_row ).offset().top; // アクティブ行のスクロールポジション値を取得
									$( 'html, body' ).animate({ scrollTop:activeRowPosition }); // 取得したアクティブ行のスクロールポジションまで移動
								}
							});
				}
			
			// 上記で定義された CSVファイルを読み込む 関数 //
			getCSV(); // ← ※ 最初に実行される )

		</script>
	</head>
	<body>
		<div id="container">
			<header id="header">
				<h1 id="app-title"><a class="clickable" href="./index.aspx"></a></h1>
				<h2 id="app-sub-title"></h2>
			</header><!--// #header -->
			<div id="content">
				<form id="form" method="get" action="./index.aspx"></form><!--// #form -->
				<div id="data"></div><!--// #data -->
			</div><!--// #content -->
			<footer id="footer">
				<p id="copyright"></p>
				<div id="to-top"></div><!--// #to-top -->
				<nav id="paging"></nav><!--// #paging -->
			</footer><!--// #footer -->
		</div><!--// #container -->
	</body>
</html>

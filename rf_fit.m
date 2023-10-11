function rf_fit(bpname,tree,pointdata,RSdata,stand_data)
% Prepare Data
% set the input and target data
p_train  = pointdata(:,1:4);
t_train  = pointdata(:,5);
p_train_1=RSdata(:,1:4);
t_train_1=RSdata(:,5);
p_train_2=stand_data(:,1:4);%around data
t_train_2=stand_data(:,5);
pb_train=[p_train_1;p_train_2];
tb_train=[t_train_1;t_train_2];
% get the train and test data for K-fold CV
p_cv_train = pb_train;%标准化用的值
t_cv_train = tb_train;
p_cv_test  = p_train;%做预测的值
t_cv_test  = t_train;
% ------------------------ construct model ----------------------------
% normalization
[p, p_set] = mapminmax(p_cv_train');
[t, t_set] = mapminmax(t_cv_train');
p = p';
t = t';
% create and train the RF model
model_rf = TreeBagger(tree, p, t, 'Method', 'regression', 'OOBPrediction', 'on'); 
% save the model
name=[bpname,'model_rf.mat'];
save(name,'model_rf','-v7.3');
% -------------------------- prediction -------------------------------
% normalize the test data
p_cv_test1 = mapminmax.apply(p_cv_test', p_set);
p_cv_test1 = p_cv_test1';
% predict the results using trained network
test_out = predict(model_rf, p_cv_test1);
% normalization reverse
test_out = mapminmax.reverse(test_out, t_set);
% compute the prediction errors
pe = t_cv_test - test_out;
% obtain the output results
rsd = [p_cv_test pe t_cv_test test_out];%test_out为真值
% output the results
output_file = [bpname,'RF_',num2str(tree),'_Fit_results.mat'];
save(output_file,'rsd');
% ----------------------------------------------------------------- END


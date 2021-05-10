run('../vlfeat-0.9.21/toolbox/vl_setup')
load('pos_neg_feats.mat')

feats = cat(1,pos_feats,neg_feats);
labels = cat(1,ones(pos_nImages,1),-1*ones(neg_nImages,1));

% lambda = 0.1;
lambda = 0.0001;
% lambda = 0.0001;

n = size(feats,1);

folds = 5;      % number of fold in kFold
iter=50;        % number of kFold CV tests

kfoldObj = cvpartition(n,'Kfold',folds);

avgAcc = 0;
highestAcc = 0;

for h = 1:iter
    fprintf(h+"\t");
    for i = 1:folds
%         fprintf("Test #"+i+"\n");
        xTrain = feats(kfoldObj.training(i),:);
        YTrain = labels(kfoldObj.training(i),:);
        xTest = feats(kfoldObj.test(i),:);
        YTest = labels(kfoldObj.test(i),:);

        [w,b] = vl_svmtrain(xTrain',YTrain',lambda);
        confidences = xTest*w + b;

    %     pulled from report accuracy to calculate accuracy
        correct_classification = sign(confidences .* YTest);
        accuracy = 1 - sum(correct_classification <= 0)/length(correct_classification);

        if accuracy > highestAcc
            highestAcc=accuracy;
            Weight=w;
            Bias=b;
        end

        avgAcc = avgAcc + accuracy;
        fprintf(accuracy + "\t");

%         fprintf('Classifier performance on train data:\n')    
%         [tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, YTest);
%         fprintf("============================================\n\n");
    end
    fprintf("\n");
end

fprintf("Average Acc:\t" + avgAcc/(folds*iter) + "\n");
fprintf("Highest Acc:\t" + highestAcc + "\n");


save('my_svm.mat','Weight','Bias');

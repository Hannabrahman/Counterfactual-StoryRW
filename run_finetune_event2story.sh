#!/bin/bash

# middle size
# fits to x1x2y and (xx2 | x1)

gpu_id=1
is_train=1
test_checkpoint="output/remove_space/train_fine_ev2st/model_best.ckpt"

output_dir="output/finetune_event2story"
config_train=config_train_finetune_event2story

config_model=configs.config_model_345M
pretrained_model_dir=gpt2_pretrained_models/model_345M
pretrain_checkpoint=gpt2_pretrained_models/model_345M/model.ckpt

mkdir -p ${output_dir}
cp $0 ${output_dir}
cp configs/${config_train}.py ${output_dir}

if [ "$is_train" = 1 ]; then ## train

  CUDA_VISIBLE_DEVICES=${gpu_id}  \
  python roc_rewriting_main.py  \
    --config_model=${config_model} \
    --pretrained_model_dir=${pretrained_model_dir} \
    --config_train=configs.${config_train} \
    --pretrain_checkpoint=${pretrain_checkpoint} \
    --output_dir=${output_dir} \
    --do_train

else ## test

  # input: x1xx2
  CUDA_VISIBLE_DEVICES=${gpu_id}  \
  python roc_rewriting_main.py  \
    --config_model=${config_model} \
    --pretrained_model_dir=${pretrained_model_dir} \
    --config_train=configs.${config_train} \
    --checkpoint=${test_checkpoint} \
    --output_dir=${output_dir} \
    --do_test \
    --finetune

  ## input: x1x2
  #CUDA_VISIBLE_DEVICES=${gpu_id}  \
  #python3 rewriting_main.py  \
  #  --config_model=${config_model} \
  #  --pretrained_model_dir=${pretrained_model_dir} \
  #  --config_train=configs.${config_train} \
  #  --test_checkpoint=${test_checkpoint} \
  #  --output_dir=${output_dir} \
  #  --do_test \
  #  --roc

fi

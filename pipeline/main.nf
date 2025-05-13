#!/usr/bin/env nextflow
// hash:sha256:68722faf240a18012a1066acd7cf8251052ccff79e598340e1c46817a798993f

nextflow.enable.dsl = 1

params.single_tile_r1_dataset_url = 's3://aind-open-data/HCR_772643_2025-02-26_10-00-00'

capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_1 = channel.create()
single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_2 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM", type: 'any')
capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_3 = channel.create()
capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_4 = channel.create()
single_tile_r1_dataset_to_aind_large_scale_cellpose_5 = channel.fromPath(params.single_tile_r1_dataset_url + "/*", type: 'any')

// capsule - aind-z1-puncta-detection
process capsule_aind_z_1_puncta_detection_1 {
	tag 'capsule-8452575'
	container "$REGISTRY_HOST/capsule/065f17f9-1aeb-45e6-bf7f-744adfd9fed3"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH/puncta_detection", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_1.flatten()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_4

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=065f17f9-1aeb-45e6-bf7f-744adfd9fed3
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8452575.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-z1-pipeline-dispatcher
process capsule_aind_z_1_pipeline_dispatcher_2 {
	tag 'capsule-7757962'
	container "$REGISTRY_HOST/capsule/e2535162-90c0-4303-910b-1d6b7faa924a"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_2.collect()

	output:
	path 'capsule/results/spot_channel_*.json' into capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_1
	path 'capsule/results/spot_channel_*.json' into capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_3

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=e2535162-90c0-4303-910b-1d6b7faa924a
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7757962.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-z1-get-multichannel
process capsule_aind_z_1_get_multichannel_3 {
	tag 'capsule-6086715'
	container "$REGISTRY_HOST/capsule/296bbc9d-a6b6-4b70-ab8a-8e6b15dba3aa"

	cpus 16
	memory '128 GB'

	publishDir "$RESULTS_PATH/puncta_statistics", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_3.flatten()
	path 'capsule/data/spots_folder/' from capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_4.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=296bbc9d-a6b6-4b70-ab8a-8e6b15dba3aa
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6086715.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-large-scale-cellpose
process capsule_aind_large_scale_cellpose_4 {
	tag 'capsule-7654769'
	container "$REGISTRY_HOST/capsule/28ca2d26-8e34-4d27-8b69-56afac9938d8"

	cpus 32
	memory '128 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH/cell_segmentation", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_large_scale_cellpose_5

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=28ca2d26-8e34-4d27-8b69-56afac9938d8
	export CO_CPUS=32
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7654769.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

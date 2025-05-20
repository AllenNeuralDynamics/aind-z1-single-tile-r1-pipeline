#!/usr/bin/env nextflow
// hash:sha256:c4f49f5167b1d275810d7d096134f37b9c60fb7215477475238aa544966fe34b

nextflow.enable.dsl = 1

params.single_tile_r1_dataset_url = 's3://aind-open-data/HCR_772643_2025-02-26_10-00-00'

single_tile_r1_dataset_to_aind_z1_puncta_detection_1 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/*.zarr", type: 'any')
capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_puncta_detection_1_2 = channel.create()
capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_3 = channel.create()
single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_4 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/derivatives/processing_manifest.json", type: 'any')
single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_5 = channel.fromPath(params.single_tile_r1_dataset_url + "/*.json", type: 'any')
single_tile_r1_dataset_to_aind_z1_get_multichannel_6 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/*.zarr", type: 'any')
capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_7 = channel.create()
capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_8 = channel.create()
single_tile_r1_dataset_to_aind_large_scale_cellpose_single_tile_copy_9 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/*.zarr", type: 'any')
single_tile_r1_dataset_to_aind_large_scale_cellpose_single_tile_copy_10 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/derivatives/processing_manifest.json", type: 'any')
single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_11 = channel.fromPath(params.single_tile_r1_dataset_url + "/SPIM/derivatives/processing_manifest.json", type: 'any')
single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_12 = channel.fromPath(params.single_tile_r1_dataset_url + "/*.json", type: 'any')
capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_pipeline_dispatcher_5_13 = channel.create()
capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_pipeline_dispatcher_5_14 = channel.create()
capsule_aind_z_1_get_multichannel_3_to_capsule_aind_z_1_pipeline_dispatcher_5_15 = channel.create()

// capsule - aind-z1-puncta-detection
process capsule_aind_z_1_puncta_detection_1 {
	tag 'capsule-8452575'
	container "$REGISTRY_HOST/capsule/065f17f9-1aeb-45e6-bf7f-744adfd9fed3:bcc5f35afc0a673c64a3c8fc1138f81b"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_z1_puncta_detection_1.collect()
	path 'capsule/data/' from capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_puncta_detection_1_2.collect()
	path 'capsule/data/' from capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_3.flatten()

	output:
	path 'capsule/results/*' into capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_8
	path 'capsule/results/*' into capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_pipeline_dispatcher_5_14

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
	git -C capsule-repo checkout ed17b82e938ef1e28090878982f977a779c4a2d5 --quiet
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
	container "$REGISTRY_HOST/capsule/e2535162-90c0-4303-910b-1d6b7faa924a:8afb77b1e88a8a02acb76ecca5bb1d13"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_4.collect()
	path 'capsule/data/input_aind_metadata/' from single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_5.collect()

	output:
	path 'capsule/results/spot_channel_*.json' into capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_puncta_detection_1_3
	path 'capsule/results/spot_channel_*.json' into capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_7

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
	git -C capsule-repo checkout 091acdf6d9c36d272782f8212c9c4ae99e672324 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run dispatch-spots

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-z1-get-multichannel
process capsule_aind_z_1_get_multichannel_3 {
	tag 'capsule-6086715'
	container "$REGISTRY_HOST/capsule/296bbc9d-a6b6-4b70-ab8a-8e6b15dba3aa:d5c231ca41058ee8230777ed38482e9d"

	cpus 16
	memory '128 GB'

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_z1_get_multichannel_6.collect()
	path 'capsule/data/' from capsule_aind_z_1_pipeline_dispatcher_2_to_capsule_aind_z_1_get_multichannel_3_7.flatten()
	path 'capsule/data/spots_folder/' from capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_get_multichannel_3_8.collect()

	output:
	path 'capsule/results/*' into capsule_aind_z_1_get_multichannel_3_to_capsule_aind_z_1_pipeline_dispatcher_5_15

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
	git -C capsule-repo checkout 253284c3d181e02832df2de32f6f5c39de6ce13f --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-large-scale-cellpose_single_tile_copy
process capsule_aind_large_scale_cellpose_4 {
	tag 'capsule-7654769'
	container "$REGISTRY_HOST/capsule/28ca2d26-8e34-4d27-8b69-56afac9938d8:abdfeec9dc3833d420123ff901c021b8"

	cpus 32
	memory '128 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_large_scale_cellpose_single_tile_copy_9.collect()
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_large_scale_cellpose_single_tile_copy_10.collect()

	output:
	path 'capsule/results/segmentation_mask.zarr' into capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_puncta_detection_1_2
	path 'capsule/results/*' into capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_pipeline_dispatcher_5_13

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
	git -C capsule-repo checkout d5bec3fb06de97e16593a8517d48224b32bc3902 --quiet
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
process capsule_aind_z_1_pipeline_dispatcher_5 {
	tag 'capsule-7757962'
	container "$REGISTRY_HOST/capsule/e2535162-90c0-4303-910b-1d6b7faa924a:8afb77b1e88a8a02acb76ecca5bb1d13"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_11.collect()
	path 'capsule/data/input_aind_metadata/' from single_tile_r1_dataset_to_aind_z1_pipeline_dispatcher_12.collect()
	path 'capsule/data/cell_segmentation/' from capsule_aind_large_scale_cellpose_4_to_capsule_aind_z_1_pipeline_dispatcher_5_13.collect()
	path 'capsule/data/puncta_detection/' from capsule_aind_z_1_puncta_detection_1_to_capsule_aind_z_1_pipeline_dispatcher_5_14.collect()
	path 'capsule/data/puncta_statistics/' from capsule_aind_z_1_get_multichannel_3_to_capsule_aind_z_1_pipeline_dispatcher_5_15.collect()

	output:
	path 'capsule/results/*'

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
	git -C capsule-repo checkout 091acdf6d9c36d272782f8212c9c4ae99e672324 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run clean_up_single_tile_r1

	echo "[${task.tag}] completed!"
	"""
}

import './bootstrap';
import { Livewire, Alpine } from '../../vendor/livewire/livewire/dist/livewire.esm';

Alpine.data('liveClock', () => ({
    time: '', interval: null,
    init() { this.update(); this.interval=setInterval(()=>this.update(),1000); },
    update() { this.time=new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}).format(new Date()).replaceAll('.',':'); },
    destroy() { clearInterval(this.interval); }
}));

Alpine.data('selfieCapture', () => ({
    stage:'intro', step:1, stream:null, preview:'', error:'', busy:false, ready:false, sending:false, needHelp:false,
    init() { this.onPageHide=()=>this.stopCamera(); window.addEventListener('pagehide',this.onPageHide); },
    async openCamera() {
        if(this.busy)return;this.error='';this.busy=true;
        if(!window.isSecureContext || !navigator.mediaDevices?.getUserMedia) {this.error='Kamera membutuhkan koneksi HTTPS. Buka aplikasi melalui alamat https://hadir.test dan izinkan kamera.';this.busy=false;return;}
        this.stopCamera();
        try {
            this.stream=await navigator.mediaDevices.getUserMedia({audio:false,video:{facingMode:{ideal:'user'},width:{ideal:1280},height:{ideal:960}}});
            this.stage='live';await this.$nextTick();this.$refs.video.srcObject=this.stream;await this.$refs.video.play();this.ready=this.$refs.video.videoWidth>0;
        } catch(error) {
            this.stopCamera();this.stage='intro';
            this.error=({NotAllowedError:'Izin kamera belum diberikan. Izinkan kamera melalui pengaturan situs di browser, lalu coba lagi.',NotFoundError:'Kamera tidak ditemukan. Gunakan perangkat berkamera atau ajukan absensi manual melalui halaman Pengajuan.',NotReadableError:'Kamera sedang dipakai aplikasi lain. Tutup aplikasi tersebut, lalu coba lagi.',OverconstrainedError:'Kamera belum dapat digunakan dengan pengaturan ini. Coba perangkat atau browser lain.'})[error.name] || 'Kamera belum dapat dibuka. Periksa izin kamera dan coba kembali.';
        } finally {this.busy=false;}
    },
    async capture() {
        this.error='';const video=this.$refs.video;
        if(!video.videoWidth || !video.videoHeight){this.error='Kamera sedang menyiapkan gambar. Tunggu sebentar lalu ambil foto kembali.';return;}
        const canvas=document.createElement('canvas');const scale=Math.min(1,960/Math.max(video.videoWidth,video.videoHeight));canvas.width=Math.round(video.videoWidth*scale);canvas.height=Math.round(video.videoHeight*scale);
        const context=canvas.getContext('2d');context.translate(canvas.width,0);context.scale(-1,1);context.drawImage(video,0,0,canvas.width,canvas.height);
        const blob=await new Promise(resolve=>canvas.toBlob(resolve,'image/jpeg',.85));
        if(!blob){this.error='Foto belum berhasil dibuat. Silakan ambil ulang.';return;}
        if(this.preview)URL.revokeObjectURL(this.preview);this.preview=URL.createObjectURL(blob);
        const transfer=new DataTransfer();transfer.items.add(new File([blob],'selfie.jpg',{type:'image/jpeg'}));this.$refs.photo.files=transfer.files;
        this.stopCamera();this.stage='preview';
    },
    async retake() {this.step=1;this.stage='intro';this.$refs.photo.value='';if(this.preview)URL.revokeObjectURL(this.preview);this.preview='';await this.openCamera();},
    usePhoto() {if(!this.$refs.photo.files.length)return;this.step=2;this.stopCamera();this.$nextTick(()=>this.$refs.review?.scrollIntoView({behavior:window.matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth',block:'start'}));},
    submit(event) {
        if(this.sending){event.preventDefault();return;}
        if(!this.$refs.photo.files.length){event.preventDefault();this.error='Ambil selfie dan periksa hasil fotonya terlebih dahulu.';return;}
        this.sending=true;this.stopCamera();
    },
    stopCamera() {this.stream?.getTracks().forEach(track=>track.stop());this.stream=null;this.ready=false;},
    destroy() {this.stopCamera();if(this.preview)URL.revokeObjectURL(this.preview);window.removeEventListener('pagehide',this.onPageHide);}
}));
Alpine.data('profilePhoto', () => ({
    preview:'', error:'', checking:false, saving:false, confirmRemove:false, objectUrl:'', selection:0,
    select(event) {
        this.reset();const file=event.target.files?.[0];if(!file)return;
        if(file.size>2*1024*1024){this.error='Ukuran foto profil maksimal 2 MB. Pilih foto yang lebih kecil.';this.$refs.photo.value='';return;}
        if(!/\.(jpe?g|png|webp)$/i.test(file.name) || (file.type && !['image/jpeg','image/png','image/webp'].includes(file.type))){this.error='Pilih gambar JPG, PNG, atau WebP.';this.$refs.photo.value='';return;}
        this.checking=true;const selection=this.selection;this.objectUrl=URL.createObjectURL(file);const image=new Image();
        image.onload=()=>{if(selection!==this.selection)return;this.checking=false;if(Math.min(image.naturalWidth,image.naturalHeight)<80||Math.max(image.naturalWidth,image.naturalHeight)>4096){this.reset(true);this.error='Ukuran foto harus 80–4096 piksel pada setiap sisi.';return;}this.preview=this.objectUrl;};
        image.onerror=()=>{if(selection!==this.selection)return;this.reset(true);this.error='Foto tidak dapat dibaca. Pilih gambar lain yang valid.';};image.src=this.objectUrl;
    },
    reset(clearInput=false) {this.selection++;if(this.objectUrl)URL.revokeObjectURL(this.objectUrl);this.objectUrl='';this.preview='';this.error='';this.checking=false;this.confirmRemove=false;if(clearInput)this.$refs.photo.value='';},
    submit(event) {if(this.saving||this.checking||!this.preview||this.error){event.preventDefault();return;}this.saving=true;},
    destroy() {this.selection++;if(this.objectUrl)URL.revokeObjectURL(this.objectUrl);}
}));
window.Alpine=Alpine;
Livewire.start();

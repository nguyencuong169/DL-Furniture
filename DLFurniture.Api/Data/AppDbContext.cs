using DLFurniture.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<NewsItem> News { get; set; } = null!;
    public DbSet<NewsCategory> NewsCategories { get; set; } = null!;
    public DbSet<GalleryCategory> GalleryCategories { get; set; } = null!;
    public DbSet<GalleryItem> GalleryItems { get; set; } = null!;
    public DbSet<Project> Projects { get; set; } = null!;
    public DbSet<BookingRequest> BookingRequests { get; set; } = null!;
    public DbSet<Testimonial> Testimonials { get; set; } = null!;
    public DbSet<TeamMember> TeamMembers { get; set; } = null!;
    public DbSet<ServiceItem> Services { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure News table
        modelBuilder.Entity<NewsItem>()
            .ToTable("news")
            .HasKey(n => n.Id);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsId)
            .HasColumnName("news_id")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Titles)
            .HasColumnName("title")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Summary)
            .HasColumnName("summary");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Content)
            .HasColumnName("content");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsImage)
            .HasColumnName("news_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.ViewCount)
            .HasColumnName("view_count")
            .HasDefaultValue(0L);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsCategoryId)
            .HasColumnName("news_category_id");

        modelBuilder.Entity<NewsItem>()
            .HasOne(n => n.NewsCategory)
            .WithMany(c => c.NewsItems)
            .HasForeignKey(n => n.NewsCategoryId)
            .OnDelete(DeleteBehavior.Restrict);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Tags)
            .HasColumnName("tags")
            .HasMaxLength(2048);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedDate)
            .HasColumnName("updated_date");

        modelBuilder.Entity<NewsCategory>()
            .ToTable("news_categories")
            .HasKey(c => c.Id);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Slug)
            .HasColumnName("slug")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.DisplayOrder)
            .HasColumnName("display_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.IsActive)
            .HasColumnName("is_active")
            .HasDefaultValue(true);

        modelBuilder.Entity<NewsCategory>()
            .HasIndex(c => c.Slug)
            .IsUnique();

        modelBuilder.Entity<GalleryCategory>(entity =>
        {
            entity.ToTable("gallery_categories");
            entity.HasKey(category => category.Id);
            entity.Property(category => category.Id).HasColumnName("id");
            entity.Property(category => category.Name).HasColumnName("name").HasMaxLength(255);
            entity.Property(category => category.Slug).HasColumnName("slug").HasMaxLength(100);
            entity.Property(category => category.DisplayOrder).HasColumnName("display_order").HasDefaultValue(0);
            entity.Property(category => category.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.HasIndex(category => category.Slug).IsUnique();
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.ToTable("projects");
            entity.HasKey(project => project.Id);
            entity.Property(project => project.Id).HasColumnName("id");
            entity.Property(project => project.Title).HasColumnName("title").HasMaxLength(255);
        });

        modelBuilder.Entity<GalleryItem>(entity =>
        {
            entity.ToTable("gallery_items", table =>
                table.HasCheckConstraint("CK_gallery_items_media_type", "[media_type] IN ('image', 'video')"));
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Id).HasColumnName("id");
            entity.Property(item => item.CategoryId).HasColumnName("category_id");
            entity.Property(item => item.ProjectId).HasColumnName("project_id");
            entity.Property(item => item.Title).HasColumnName("title").HasMaxLength(255);
            entity.Property(item => item.Description).HasColumnName("description");
            entity.Property(item => item.MediaType).HasColumnName("media_type").HasMaxLength(20);
            entity.Property(item => item.MediaUrl).HasColumnName("media_url").HasMaxLength(1024);
            entity.Property(item => item.ThumbnailUrl).HasColumnName("thumbnail_url").HasMaxLength(1024);
            entity.Property(item => item.AltText).HasColumnName("alt_text").HasMaxLength(500);
            entity.Property(item => item.Provider).HasColumnName("provider").HasMaxLength(30).HasDefaultValue("local");
            entity.Property(item => item.Duration).HasColumnName("duration").HasMaxLength(20);
            entity.Property(item => item.IsFeatured).HasColumnName("is_featured").HasDefaultValue(false);
            entity.Property(item => item.DisplayOrder).HasColumnName("display_order").HasDefaultValue(0);
            entity.Property(item => item.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.Property(item => item.CreatedAt).HasColumnName("created_at").HasDefaultValueSql("SYSUTCDATETIME()");
            entity.Property(item => item.UpdatedAt).HasColumnName("updated_at").HasDefaultValueSql("SYSUTCDATETIME()");
            entity.HasOne(item => item.Category)
                .WithMany(category => category.GalleryItems)
                .HasForeignKey(item => item.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(item => item.Project)
                .WithMany(project => project.GalleryItems)
                .HasForeignKey(item => item.ProjectId)
                .OnDelete(DeleteBehavior.SetNull);
            entity.HasIndex(item => new { item.IsActive, item.MediaType, item.DisplayOrder });
            entity.HasIndex(item => new { item.IsActive, item.MediaType, item.UpdatedAt });
            entity.HasIndex(item => item.ProjectId);
        });

        modelBuilder.Entity<BookingRequest>(entity =>
        {
            entity.ToTable("booking_requests");
            entity.HasKey(request => request.Id);
            entity.Property(request => request.Id).HasColumnName("id");
            entity.Property(request => request.FullName).HasColumnName("full_name").HasMaxLength(255);
            entity.Property(request => request.Email).HasColumnName("email").HasMaxLength(255);
            entity.Property(request => request.Phone).HasColumnName("phone").HasMaxLength(50);
            entity.Property(request => request.Message).HasColumnName("message");
            entity.Property(request => request.Source)
                .HasColumnName("source")
                .HasMaxLength(100)
                .HasDefaultValue("consultation_form");
            entity.Property(request => request.Status)
                .HasColumnName("status")
                .HasMaxLength(50)
                .HasDefaultValue("pending");
            entity.Property(request => request.CreatedAt)
                .HasColumnName("created_at")
                .HasDefaultValueSql("GETDATE()");
            entity.Property(request => request.UpdatedAt)
                .HasColumnName("updated_at")
                .HasDefaultValueSql("GETDATE()");
        });

        // Configure Testimonials table
        modelBuilder.Entity<Testimonial>()
            .ToTable("testimonials")
            .HasKey(t => t.Id);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CustomerName)
            .HasColumnName("customer_name")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Location)
            .HasColumnName("location")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Content)
            .HasColumnName("content");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Rating)
            .HasColumnName("rating")
            .HasDefaultValue(5);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");

        // Configure TeamMembers table
        modelBuilder.Entity<TeamMember>()
            .ToTable("team_members")
            .HasKey(t => t.Id);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FullName)
            .HasColumnName("full_name")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Role)
            .HasColumnName("role")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Email)
            .HasColumnName("email")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FacebookUrl)
            .HasColumnName("facebook_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.TwitterUrl)
            .HasColumnName("twitter_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.InstagramUrl)
            .HasColumnName("instagram_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.PinterestUrl)
            .HasColumnName("pinterest_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");

        // Configure Services table
        modelBuilder.Entity<ServiceItem>()
            .ToTable("services")
            .HasKey(s => s.Id);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Id)
            .HasColumnName("id");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Description)
            .HasColumnName("description");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Image)
            .HasColumnName("image")
            .HasMaxLength(1024);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Category)
            .HasColumnName("category")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");
    }
}
